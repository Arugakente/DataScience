multiCount = true;

a = 0.85;

files = glob("/Users/guillaume/Documents/Travail/2020-2021/data_science/Projets/DataScienceP1/Dataset/processed/*.txt");

n = ones(numel(files),1);

M = zeros(numel(files),numel(files));

invertedIndex = containers.Map();

stopwordsMap = containers.Map();
stopwordsMap("") = 0;

%chagement de la liste des stopwords
stopwords = textread("/Users/guillaume/Documents/Travail/2020-2021/data_science/Projets/DataScienceP1/stopwords.txt", "%s");
for i=1:numel(stopwords)
  stopwordsMap(stopwords{i}) = 0;
  disp(stopwords{i});
endfor

for i=1:numel(files)
  currentFile = textread(files{i}, "%s");
  linkFrom = str2num(substr(files{i},rindex(files{i},"/") + 5, rindex(files{i},".") - (rindex(files{i},"/") + 5)));
  for j=1:numel(currentFile)
    disp(i)
    disp(numel(files))
    disp(j)
    disp(numel(currentFile))
    currentWord = currentFile{j};
    if isempty(regexp(currentWord,"linkTo:.*")) == 0 %On traite le lien
      linkTo = str2num(substr(currentWord,index(currentWord,":")+5,index(currentWord,".")-(index(currentWord,":")+5)));
      if linkTo != linkFrom
        if multiCount
          M(linkFrom,linkTo)+=1;
        else  
          M(linkFrom,linkTo)=1;
        endif
      endif
    else %On traite le mot
      currentWord = tolower(currentWord);
      currentWord = strtrim(currentWord);
      currentWord = regexprep(currentWord,'[\.\,\(\)«»—]','');
      #retrait des mots non porteurs de sens (via une liste de mot préchargée) et élimination des composantes n'étant pas des mots.
      if !isKey(stopwordsMap,currentWord) && !isempty(currentWord) && isempty(regexp(currentWord,'[!@#\$%\^&*()_+\=\[\]{};:"\\|,.<>\/?]|[0-9]'))
        %nettoyage des mots   
        if isKey(invertedIndex,currentWord)
          tmp = invertedIndex(currentWord);
          tmp(linkFrom) = 1;
          invertedIndex(currentWord) = tmp;
        else %On rajoute le mot � la liste
          tmp = zeros(1,numel(files));
          tmp(linkFrom) = 1;
          invertedIndex(currentWord) = tmp;
        endif
     endif
    endif
  endfor
endfor

disp(M);

for i=1:size(M)(1)
  somme = sum(M(:,i));
  
  for j=1:size(M)(2)
    if somme == 0
      M(j,i) = 1 / size(M)(1); %pour bien avoir un syst�me de Markov
    else
      M(j,i) = M(j,i)/somme; %normalisation
    endif
    M(j,i) = a*M(j,i) + 1*(1-a) / size(M)(1); %formule matrice de google
  endfor
  
  disp(sum(M(:,i)));
endfor

disp(M);

T = 10;

x = zeros(size(M)(1), T);
x(:,1) = n;

for i=1:T
    n = M*n;
    x(:,i+1) = n;
endfor

figure(1);
plot(0:T, x(1,:));
hold on;

for i=2:size(M)(1)
  plot(0:T, x(i,:));
endfor 

legend(files');