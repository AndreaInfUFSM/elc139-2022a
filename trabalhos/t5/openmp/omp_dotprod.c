#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

typedef struct
{
    double *a;
    double *b;
} dotdata_t;

dotdata_t dotdata;
double c = 0.0;
int wsize;
int repeat;


void dotprod_threads(int nthreads)
{
    int share;
    omp_set_num_threads(nthreads);
    #pragma omp parallel for reduction (+: c) shared(dotdata, wsize, repeat, nthreads) default(none)
    for (share = 0; share < nthreads; share++) {
        int i, k;
        int start = share * wsize;
        int end = start + wsize;
        double mysum = 0.0;

        for (k = 0; k < repeat; k++) {
            mysum = 0.0;
            for (i = start; i < end ; i++)  {
                mysum += (dotdata.a[i] *  dotdata.b[i]);
            }
        }

        c += mysum;
    }

}

long wtime()
{
    struct timeval t;
    gettimeofday(&t, NULL);
    return t.tv_sec*1000000 + t.tv_usec;
}

void fill(double *a, int size, double value)
{
    int i;
    for (i = 0; i < size; i++) {
        a[i] = value;
    }
}

int main(int argc, char **argv)
{
    int nthreads;
    long start_time, end_time;

//    #pragma omp parallel
//    printf("Hello World\n");
//    return 0;

    if ((argc != 4)) {
        printf("Uso: %s <nthreads> <worksize> <repetitions>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    nthreads = (int) strtol(argv[1],NULL,10);
    wsize = (int) strtol(argv[2],NULL,10);
    repeat = (int) strtol(argv[3],NULL,10);

    dotdata.a = (double *) malloc(wsize*nthreads*sizeof(double));
    fill(dotdata.a, wsize*nthreads, 0.01);
    dotdata.b = (double *) malloc(wsize*nthreads*sizeof(double));
    fill(dotdata.b, wsize*nthreads, 1.0);

    // Calcula c = a . b em nthreads, medindo o tempo
    start_time = wtime();
    dotprod_threads(nthreads);
    end_time = wtime();

    // Mostra resultado e estatisticas da execucao
    printf("%f\n", c);
    printf("%d thread(s), %ld usec\n", nthreads, (long) (end_time - start_time));
    fflush(stdout);

    free(dotdata.a);
    free(dotdata.b);

    return EXIT_SUCCESS;
}

