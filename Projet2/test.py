from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
import pandas as pnd
import seaborn as sns
import numpy as np
import matplotlib.pyplot as plt

df = pnd.read_csv("./Dataset/dataset.csv",header=0,index_col=0)
#dimension
print(df.shape) # (18, 6)
#nombre d'observations
n = df.shape[0]
#nombre de variables
p = df.shape[1]
#affichage des données
print(df)

#instanciation
sc = StandardScaler()
#transformation – centrage-réduction
Z = sc.fit_transform(df)
print(Z)

#moyenne
print(np.mean(Z,axis=0))
#écart-type
print(np.std(Z,axis=0,ddof=0))

# Do the PCA.
acp = PCA(svd_solver='full')
coord = acp.fit_transform(Z)

print(df.head())

#variance expliquée
print(acp.explained_variance_ratio_)

# Do a scree plot
ind = np.arange(0, n)
(fig, ax) = plt.subplots(figsize=(8, 6))
sns.pointplot(x=ind, y=acp.explained_variance_ratio_)
ax.set_title('Scree plot')
ax.set_xticks(ind)
ax.set_xticklabels(ind)
ax.set_xlabel('Component Number')
ax.set_ylabel('Explained Variance')
plt.show()

#positionnement des individus dans le premier plan
fig, axes = plt.subplots(figsize=(12,12))
axes.set_xlim(-6,6) #même limites en abscisse
axes.set_ylim(-6,6) #et en ordonnée
#placement des étiquettes des observations
for i in range(n):
    plt.annotate(df.index[i],(coord[i,0],coord[i,1]))
#ajouter les axes
plt.plot([-6,6],[0,0],color='silver',linestyle='-',linewidth=1)
plt.plot([0,0],[-6,6],color='silver',linestyle='-',linewidth=1)
#affichage
plt.show()

#valeur corrigée
eigval = (n-1)/n*acp.explained_variance_
print(eigval)

#racine carrée des valeurs propres
sqrt_eigval = np.sqrt(eigval)

#corrélation des variables avec les axes
corvar = np.zeros((p,p))
for k in range(n):
 corvar[:,k] = acp.components_[k,:] * sqrt_eigval[k]

#afficher la matrice des corrélations variables x facteurs
print(corvar)

#cercle des corrélations
fig, axes = plt.subplots(figsize=(8,8))
axes.set_xlim(-1,1)
axes.set_ylim(-1,1)
#affichage des étiquettes (noms des variables)
for j in range(p):
    plt.annotate(df.columns[j],(corvar[j,0],corvar[j,1]))

#ajouter les axes
plt.plot([-1,1],[0,0],color='silver',linestyle='-',linewidth=1)
plt.plot([0,0],[-1,1],color='silver',linestyle='-',linewidth=1)

#ajouter un cercle
cercle = plt.Circle((0,0),1,color='blue',fill=False)
axes.add_artist(cercle)
#affichage
plt.show()