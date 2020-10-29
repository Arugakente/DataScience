#Program Parameters
multiCount = true;
keywordCount = true;
a = 0.60;
epsilon = 0.001;




workspace = pwd();
files = glob(strcat(workspace,"/Dataset/smallExample4WS/processed/*.txt")); 

n = ones(numel(files),1);
M = zeros(numel(files),numel(files));

invertedIndex = containers.Map();

stopwordsMap = containers.Map();
stopwordsMap("") = 0;

#List of site name
labels = [];

%Stopwords list loading
stopwords = textread("stopwords.txt", "%s");

for i=1:numel(stopwords)
  stopwordsMap(stopwords{i}) = 0;
  %disp(stopwords{i});
endfor


readed = "";
slash = "/";
do
  readed = input("Is Windows your OS ? (Y/N) : ","s");
  if strcmp(readed,"Y")
    slash = "\\";
    break;
  else
    if strcmp(readed,"N")
      break;
    else 
      disp("Erreur, veuillez r�essayer.");
    endif
  endif
until (strcmp(readed,"Y") || strcmp(readed,"N"))



for i=1:numel(files)
  #Storing filename for graph labeling and result displaying
  labels{i} = substr(files{i},rindex(files(i),slash)+1);
  currentFile = textread(files{i}, "%s");
  linkFrom = str2num(substr(files{i},rindex(files{i},slash) + 5, rindex(files{i},".") - (rindex(files{i},slash) + 5)));
  
  for j=1:numel(currentFile)
    disp(strcat("file: ",num2str(i),slash,num2str(numel(files))," | word: ",num2str(j),slash,num2str(numel(currentFile))))
    currentWord = currentFile{j};
    
    if isempty(regexp(currentWord,"linkTo:.*")) == 0 %Link processing
      linkTo = str2num(substr(currentWord,index(currentWord,":")+5,index(currentWord,".")-(index(currentWord,":")+5)));
      
      if linkTo != linkFrom
        if multiCount
          M(linkFrom,linkTo)+=1;
        else  
          M(linkFrom,linkTo)=1;
        endif
      endif
      
    else %Words processing
      currentWord = tolower(currentWord);
      currentWord = strtrim(currentWord);
      currentWord = regexprep(currentWord,'[\.\,\(\)«»—]','');
      
      %Words cleaning
      if !isKey(stopwordsMap,currentWord) && !isempty(currentWord) && isempty(regexp(currentWord,'[!@#\$%\^&*()_+\=\[\]{};:"\\|,.<>\/?]|[0-9]'))
        
        if isKey(invertedIndex,currentWord) %Already on list
          tmp = invertedIndex(currentWord);
          tmp(i) = 1;
          invertedIndex(currentWord) = tmp;
          
        else %Not in the list
          tmp = zeros(1,numel(files));
          tmp(i) = 1;
          invertedIndex(currentWord) = tmp;
        endif
        
     endif
    endif
  endfor
endfor

disp(M);



%Markov matrix creation

for i=1:size(M)(1)
  somme = sum(M(:,i));
  
  for j=1:size(M)(2)
    if somme == 0
      M(j,i) = 1 / size(M)(1); %To ensure we have a Markov system 
    else
      M(j,i) = M(j,i)/somme; %Normalization
    endif
    M(j,i) = a*M(j,i) + 1*(1-a) / size(M)(1); %Google Matrix formula
  endfor
  
  %disp(sum(M(:,i)));
endfor

disp(M);

T = 30; %Delta time buffer

x = zeros(size(M)(1), T);
x(:,1) = n;

maxTime = T;


%Markov simulation
for i=1:T
    n = M*n;
    x(:,i+1) = n;
    
    if norm(x(:,i+1)-x(:,i)) < epsilon
      maxTime = i+1;
      break;
    endif
endfor

figure(1);
plot(0:maxTime-1, x(1,1:maxTime));
hold on;

for i=2:size(M)(1)
  plot(0:maxTime-1, x(i,1:maxTime));
endfor 
legend(labels');
disp(n);





#Request section over the loaded datas (seach engine)
#    Main criterion: number of keyword match(toggleable)
#    For site with same keyword match: verification with the pagerank to sort

readed = "";

do
  readed = input("Keywords to search (/quit to quit) : ","s");
  
  keywordMatch = zeros(1,numel(files));
  ranking = zeros(1,numel(files));
  
  if !strcmp(readed,"/quit")
    readed = strsplit(readed);
    
    for i=1:numel(readed)
      currentWord = tolower(readed{i});
      if isKey(invertedIndex,currentWord)
        if(keywordCount)    %Adding pages that contains one of our words
          keywordMatch += invertedIndex(currentWord); 
        else                %Storing pages that contains every words
          keywordMatch = or(keywordMatch,invertedIndex(currentWord));
        endif
      endif
    endfor
    
    if(keywordCount)
      for i=1:numel(files)
        stored = false;
        updatePoint = 0;
        if keywordMatch(i) != 0
          j=1;
          while j<=numel(files) && !stored
            if ranking(j) == 0
              ranking(j)=i;
              stored = true;
            elseif keywordMatch(ranking(j))<keywordMatch(i) || (keywordMatch(ranking(j))==keywordMatch(i)&&n(ranking(j))<n(i))
              updatePoint = j;
              stored = true;
            else
             j+=1;
            endif
          endwhile
          #insertion if necessary
          if updatePoint !=0
            tmp1 = i;
            tmp2 = ranking(updatePoint);
            j = updatePoint;
            stored = false;
            while j<=numel(files) && !stored
              if ranking(j) == 0 || j == numel(files)
                ranking(j) = tmp1;
                stored =true;
              else
                ranking(j) = tmp1;
                tmp1 = tmp2;
                tmp2 = ranking(j+1);
              endif
              j+=1;
            endwhile
          endif 
        endif
      endfor
    else
      for i=1:numel(files)
        stored = false;
        updatePoint = 0;
        if keywordMatch(i) != 0
          j=1;
          while j<=numel(files) && !stored
            if ranking(j) == 0
              ranking(j)=i;
              stored = true;
            elseif n(ranking(j))<n(i)
              updatePoint = j;
              stored = true;
            else
             j+=1;
            endif
          endwhile
          #insertion if necessary
          if updatePoint !=0
            tmp1 = i;
            tmp2 = ranking(updatePoint);
            j = updatePoint;
            stored = false;
            while j<=numel(files) && !stored
              if ranking(j) == 0 || j == numel(files)
                ranking(j) = tmp1;
                stored =true;
              else
                ranking(j) = tmp1;
                tmp1 = tmp2;
                tmp2 = ranking(j+1);
              endif
              j+=1;
            endwhile
          endif 
        endif
      endfor
    endif 
    disp("Search results:");
    for i=1:numel(ranking)
      if(ranking(i) != 0)
        disp(strcat(num2str(i),": ",labels{ranking(i)}))
      endif
    endfor
  endif
until strcmp(readed,"/quit")
