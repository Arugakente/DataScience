#Via le nombre de lien
n = ones(15,1);
multiCount = true;

files = glob("/Users/guillaume/Documents/Travail/2020-2021/data_science/Projets/DataScienceP1/Dataset/processed/*.txt");

M = zeros(numel(files),numel(files));

for i=1:numel(files)
  currentFile = textread (files{i}, "%s");
  linkFrom = str2num(substr(files{i},rindex(files{i},"/")+5,rindex(files{i},".")-(rindex(files{i},"/")+5)));
  for j =1:numel(currentFile)
      currentWord = currentFile{j};
      if  isempty(regexp(currentWord,"linkTo:.*")) == 0
          linkTo = str2num( substr(currentWord,index(currentWord,":")+5,index(currentWord,".")-(index(currentWord,":")+5)));
          if linkTo != linkFrom
                if  multiCount
                  M(linkFrom,linkTo)+=1;
                else  
                  M(linkFrom,linkTo)=1;
                endif
           endif
      endif

      endfor
endfor

disp(M);

for i=1:size(M)(1)
  somme = sum(M(:,i));
  
  for j=1:size(M)(2)
    M(j,i) = M(j,i)/somme;
  endfor
  
  disp(sum(M(:,i)));
endfor

disp(M);

T = 10;

x = zeros(size(M)(1), T);
x(:,1) = n; #x initial

for i=1:T
    n = M*n;
    x(:,i+1) = n;
endfor

figure(1);
plot(0:T, x(1,:));
hold on;

for i=1:size(M)(1)
  plot(0:T, x(i,:));
endfor