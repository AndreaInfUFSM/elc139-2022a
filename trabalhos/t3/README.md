# T3: Profiling de algoritmos de machine learning do Weka / wekaPython


## Motivação

Weka é uma ferramenta desenvolvida na Universidade de Waikato, na Nova Zelândia. É uma ferramenta consolidada e muito popular na área de data mining, oferecendo diversos algoritmos de machine learning e facilidades para aplicá-los via interface gráfica ou via código Java.

Weka permite a instalação de pacotes que estendem suas funcionalidades. Um desses pacotes é o wekaPython, que habilita o Weka a invocar bibliotecas em Python, tais como scikit-learn. Com isso, é possível combinar facilidades do Weka com estas bibliotecas.

Uma execução típica do Weka compreende a carga de um dataset e seu processamento com um algoritmo escolhido. 
Muitos algoritmos podem exigir um tempo de execução significativo para datasets com muitas instâncias e atributos.
Mas como esse tempo de execução se divide entre as diversas partes do Weka e das bibliotecas em Python? Será que é possível fazer profiling disso? 


## Preparação

1. Instale o Weka, o wekaPython e suas dependências. Isso está descrito nos passos 1 a 4 da seção de Preparação/Instalação em https://github.com/cassales/progpar-2022-profiling

2. Baixe o dataset GMSC indicado em: https://github.com/cassales/progpar-2022-profiling#datasets Após descompactá-lo, vai ser gerado um arquivo GMSC.arff. Verifique a localização (path) para esse arquivo, pois vai ser necessário no passo seguinte.

3. Execute o Weka com o algoritmo XGBoost para o dataset GMSC:
   ```
   $ cd weka-3-8-6
   $ ./weka.sh -memory 32g -main weka.Run weka.classifiers.sklearn.ScikitLearnClassifier -learner XGBClassifier -parameters "tree_method=\"hist\",n_jobs=1" -t ~/Downloads/datasets/GMSC.arff -py-command python
   ```
   No comando acima, altere `~/Downloads/datasets` para a localização do arquivo GMSC.arff em seu computador.


4. Avise a professora quando terminar esses passos, para "desbloquear" os passos seguintes. 😃


# Profilers para Java

Como o Weka é desenvolvido em Java, podemos usar profilers especializados em Java para entender o comportamento das execuções de seus algoritmos. Existem muitos profilers para Java, por exemplo: VisualVM, JProfiler, YourKit, Java Flight Recorder (JFR) + Java Mission Control (JMC), async-profiler, etc. Em geral, essas ferramentas são "sensíveis" às versões/implementações do Java. Assim, pode ser uma boa ideia descobrir mais sobre isso no Weka, antes de escolher um profiler (ou não :smiley:).

# Desenvolvimento

Para desenvolver este trabalho, vamos dividir as tarefas entre grupos/estudantes. Essas tarefas envolvem:

1. Repetir execuções com diferentes algoritmos (XGBoost, RandomForest e LinearRegression) e datasets, em diferentes computadores/SOs.
2. Repetir execuções com diferentes quantidades de jobs (parâmetro `n_jobs`, ver em https://github.com/cassales/progpar-2022-profiling#sugest%C3%B5es-de-algoritmos-para-fazer-o-profiling).
3. Criar scripts em Python que chamem diretamente os algoritmos XGBoost, RandomForest e LinearRegression, retornando resultados equivalentes às execuções via Weka.
4. Comparar execuções dos algoritmos via Weka com execuções em Python: qual será o impacto no tempo de execução?



