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



# Desenvolvimento


Vamos realizar execuções com diferentes algoritmos (XGBoost, RandomForest e LinearRegression) e datasets, em diferentes computadores. Também vamos variar o parâmetro `n_jobs` entre diferentes rodadas, para ativar a execução paralela dos algoritmos.
As execuções serão feitas com e sem coleta de dados para profiling, que será feito combinando as ferramentas JFR (Java Flight Recorder) e JMC (Java Mission Control).

Para facilitar as execuções, é fornecido um script que automatiza o processo, lendo as variáveis dos experimentos de um arquivo e salvando todos os resultados em uma pasta, de forma padronizada.

Para realizar as execuções, faça o seguinte:

1. Confira se você consegue executar o Weka via `weka.sh`, conforme instruções da seção de Preparação. 

2. Baixe uma versão alterada do `weka.sh`, que tem uma opção para ativar a coleta de dados com JFR. Faça isso dentro da pasta do Weka. Por exemplo:
   ```
   cd ~/Downloads/weka-3-8-6
   wget ...
   ```

3. Em uma pasta separada, baixe o script que automatiza as rodadas, o arquivo com as variáveis dos experimentos e um arquivo com configurações para o JFR:
   ```
   wget ...
   wget ...
   wget ...
   ```
   **Atenção!** Estes arquivos devem ficar todos na mesma pasta.

4. Abra o script [run-exps.sh](run-exps.sh) e ajuste as variáveis com a localização do Weka e dos datasets. Certifique-se de que você tenha datasets na pasta indicada.

5. Abra o arquivo [exp-vars.csv](exp-vars.csv) e veja que são fornecidos alguns exemplos de parâmetros para as rodadas. Para iniciar, é conveniente executar somente um caso de teste. Isso pode ser feito removendo os outros casos, mantendo somente as 2 primeiras linhas do arquivo (a primeira contém um cabeçalho e a segunda contém parâmetros para a execução).

6. Para executar o script que automatiza as rodadas, vá para a pasta que contém o script e digite:
   ```
   bash run-exps.sh
   ```
   Se tudo der certo, será criada uma pasta de resultados contendo alguns arquivos:
   - times.csv: contém tempos de execução de cada caso
   - arquivos com extensão .txt: contêm saídas do Weka para cada caso
   - arquivos com extensão .jfr: contêm informações para profiling e podem ser examinados usando o JMC obtido em: https://www.azul.com/products/components/zulu-mission-control/

7. Depois de executar o script para um caso, você pode acrescentar outros algoritmos, datasets e valores de `n_jobs` em [exp-vars.csv](exp-vars.csv). 

8. Quando tiver realizado os experimentos, entregue todos os arquivos com resultados em https://classroom.github.com/a/SRjt-pEL e preencha o relatório compartilhado (link para Google Docs será enviado no Discord).




# Questões

1. Qual o efeito do parâmetro `n_jobs` sobre o tempo de execução de cada algoritmo e dataset? 

2. Usando o JMC, como o tempo de execução se divide entre os diversos métodos invocados em cada caso? (veja Method Profiling no JMC)
