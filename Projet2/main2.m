#Program Parameters



%Data Loading
workspace = pwd();
csv = csvread(strcat(workspace,"/Dataset/dataset.csv")); 
txt = textread(strcat(workspace,"/Dataset/dataset.csv"),"%s"); %for titles

N = csv(2:size(csv)(1), 2:size(csv)(2)); %without columns and rows titles

rows = cell(size(N)(1),1);
columns = cell(size(N)(2),1);

columns = ostrsplit(txt(1){:}, ",")(2:size(N)(2)+1); %without row x column title
for i=2:size(txt)
  rows(i-1) = ostrsplit(txt(i){:}, ",")(1); %only take the row title
endfor

%disp(columns);


%Matrix processing
%AFC (chi)

%hand, foot and total
ni = sum(N,2);
nj = sum(N,1);
n = sum(sum(N,2),1);

U = (ni * nj) / n;

%chi = size(N)(2);
for j=1:size(N)(2)
  %chi = sum( ( ((N(:,j))-U(:,j)) / sqrt(U(:,j)) )^2 );
endfor
%chi *= 1/(size(N)(1)-1);

X = (N-U) ./ sqrt(U); %X matrix for ACP computing
disp(X);

%ACP