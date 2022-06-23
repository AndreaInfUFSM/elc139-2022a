
#include <stdio.h>
#include <stdlib.h>

#define N (30)

int main(int argc, char *argv[])
{
    int idx;
    float a[N], b[N], c[N];

    for(idx=0; idx<N; ++idx)
    {
        a[idx] = b[idx] = 1.0;
    }

    for(idx=0; idx<N; ++idx)
    {
        c[idx] = a[idx] + b[idx];

        printf("c[%2d]=%.2f\n", idx, c[idx]);
    }
    return 0;
}
