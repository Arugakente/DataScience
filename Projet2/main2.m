#pkg install "./geometry-1.2.2.tar.gz";
pkg load geometry;
#Program Parameters



%Data Loading
workspace = pwd();
csv = csvread(strcat(workspace,"/Dataset/datasetCleaned.csv")); 
txt = textread(strcat(workspace,"/Dataset/datasetCleaned.csv"),"%s"); %for titles

N = csv(2:size(csv)(1), 2:size(csv)(2)); %without columns and rows titles

lines = cell(size(N)(1),1);
cols = cell(size(N)(2),1);

cols = ostrsplit(txt(1){:}, ",")(2:size(N)(2)+1); %without row x column title
for i=2:size(txt)
  lines(i-1) = ostrsplit(txt(i){:}, ",")(1); %only take the row title
endfor

%disp(cols);


%Matrix processing
%ACP

X = N

disp("ACP DEBUG HERE")

#for easier debug : 
#X = X(:,[10,11,12,13]); 
#X = X(:,[6,24,10,11]); 
#X = X(:,[6,2,7,10,1,5]); 
#disp(X);

#calcul de la matrice variance/covariance:
moy = mean(X);

Etype = std(X);
disp(Etype)

#figure(2)
#scatter(X(:,1),X(:,2))
#figure(3)
#scatter(X(:,3),X(:,4))


#Normalization (reducing and centering)
Xred = zeros(rows(X),columns(X));
Xnorm = zeros(rows(X),columns(X));


for i=1:columns(X)
   Xred(:,i)=(X(:,i)-moy(i));
   Xnorm(:,i)=Xred(:,i)/Etype(i);
endfor

#verification de la standardisation :
#calcul de la matrice variance/covariance:
disp("Matrice de covariance")
covariance = cov(Xred);
disp(covariance);
disp("Matrice de correlation")
#V1=(1/rows(Xnorm)).*(Xnorm'*Xnorm); #méthode de calcul classique
correl=cov(Xnorm);
disp(correl);
disp("std dev");
disp(std(Xnorm));
disp("avg");
disp(mean(Xnorm));
disp("X standardized");
disp(Xnorm);

#figure(4)
#scatter(Xnorm(:,1),Xnorm(:,2))
#figure(5)
#scatter(Xnorm(:,3),Xnorm(:,4))

#Diagonalization
[E,D] = eig(Xnorm'*Xnorm);

#reverse order (asc to dsc)
dim = columns(D);
for i=1:round(dim/2)
  
  tmpD = D(dim-i+1,dim-i+1);
  disp(tmpD);
  D(dim-i+1,dim-i+1) = D(i,i);
  D(i,i) = tmpD;
  
  tmpE = E(:,dim-i+1);
  E(:,dim-i+1) = E(:,i);
  E(:,i) = tmpE;
endfor

V = E * ((D/rows(X)).^(1/2));

disp(columns(Xnorm))

infoTot = sum(diag(D));
percentInfo = (diag(D)/infoTot)*100;

#cumulative information
cumulInfo = zeros(size(percentInfo));
cumulInfo(1) = percentInfo(1);
for i=2:size(percentInfo)
  cumulInfo(i) = cumulInfo(i-1) + percentInfo(i);
endfor

disp("eigenValues");
disp(D);
disp("eigenVectors");
disp(E);
#figure(6);
#bar(diag(D));
figure(7);
bar(percentInfo);

figure(8);
bar(cumulInfo);

finalValues = Xnorm*E*D^-(1/2);


#{
#selecting 2 bests dimentions
first = 1;
second = 1;

maxFirst = 1;
maxSecond = 1;
maxThird = 1;
max

max = 0;

while(first<=rows(D))
  if D(first,first)
    max = D(first,first);
    maxFirst = first;
  endif
  first += 1;
endwhile

max = 0;
while(second<=rows(D))
  if D(second,second) > max && second != maxFirst
    max = D(second,second);
    maxSecond = second;
  endif
  second += 1;
endwhile

disp(maxFirst)
disp(maxSecond)
#}

#drawing of the correlation circle
figure(9)

x=0;
y=0;
r1=1;
drawCircle(x,y,r1);
hold on
quiver(zeros(1,rows(V)),zeros(1,rows(V)),V(:,1),V(:,2),'AutoScale','off');
set(gca, 'DataAspectRatio', [1 1 1])

for i=1:columns(finalValues)
  text(V(i,1)+0.01,V(i,2)+0.01,cols(1,i), "interpreter", "none");
endfor

#drawing of the correlation circle
figure(10)

x=0;
y=0;
r1=1;
drawCircle(x,y,r1);
hold on
quiver(zeros(1,rows(V)),zeros(1,rows(V)),V(:,3),V(:,4),'AutoScale','off');
set(gca, 'DataAspectRatio', [1 1 1])

for i=1:columns(finalValues)
  text(V(i,3)+0.01,V(i,4)+0.01,cols(1,i), "interpreter", "none");
endfor



#getting limits of each axis (to avoid figure resizing)
min1 = inf;
max1 = -inf;

min2 = inf;
max2 = -inf;

min3 = inf;
max3 = -inf;

min4 = inf;
max4 = -inf;

for i=1:rows(finalValues)
  if finalValues(i,1) > max1
    max1 = finalValues(i,1);
  endif    
  if finalValues(i,1) < min1
    min1 = finalValues(i,1);
  endif
  
   if finalValues(i,2) > max2
    max2 = finalValues(i,2);
  endif    
  if finalValues(i,2) < min2
    min2 = finalValues(i,2);
  endif
  
   if finalValues(i,3) > max3
    max3 = finalValues(i,3);
  endif    
  if finalValues(i,3) < min3
    min3 = finalValues(i,3);
  endif
  
   if finalValues(i,4) > max4
    max4 = finalValues(i,4);
  endif    
  if finalValues(i,4) < min4
    min4 = finalValues(i,4);
  endif
endfor

disp(max1);
disp(min1);
disp(max2);
disp(min2);
disp(max3);
disp(min3);
disp(max4);
disp(min4);

#drawing with main axis

figure(11)
axis([min1;max1;min2;max2])
for i=1:rows(finalValues)
  text(finalValues(i,1),finalValues(i,2),lines(i), "interpreter", "none");
endfor
xlabel(strcat("factor1 :",num2str(percentInfo(1),4)," %"));
ylabel(strcat("factor2 :",num2str(percentInfo(2),4)," %"));
#PAS METTRE AUTANT DE CHIFFRE APRES LA VIRGULE

#drawing with 3rd and 4th axis

figure(12)
axis([min3;max3;min4;max4])
for i=1:rows(finalValues)
  text(finalValues(i,3),finalValues(i,4),lines(i), "interpreter", "none");
endfor

xlabel(strcat("factor3 :",num2str(percentInfo(3),3)," %"));
ylabel(strcat("factor4 :",num2str(percentInfo(4),3)," %"));
#PAS METTRE AUTANT DE CHIFFRE APRES LA VIRGULE
