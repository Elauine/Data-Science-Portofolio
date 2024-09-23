# Script Mémoire Elauïne BERNARD

# ********************************---1-Préliminaires ---*******************************************

# Accès aux packages
install.packages("readxl")
install.packages("tseries")
install.packages("vars")

library(readxl)
library(tseries)
library(vars)


# Import de la base de données
base=read_excel("Base_R.xlsx")
View(base)
# Aperçu des premières lignes de la base
head(base)
# Création des variables taux 
tx_pindust=(diff(base$Indice_Production_Industrielle) / lag(base$Indice_Production_Industrielle, k = -1)) * 100
tx_ppetrole=(diff(base$Prix_Petrole) / lag(base$Prix_Petrole, k = -1)) * 100
tx_pgaz=(diff(base$Prix_GNL) / lag(base$Prix_GNL, k = -1)) * 100

# Création des séries de taux
serie_pindust<-ts(tx_pindust,start=c(2011,2),frequency=12)
serie_petrole<-ts(tx_ppetrole,start=c(2011,2),frequency=12)
serie_gaz<-ts(tx_pgaz,start=c(2011,2),frequency=12)

# ******************************--2-Analyse Exploratoire ---***********************************

# 2.1- Représentation graphique des séries

plot(serie_pindust,xlab='Année',ylab='Taux de croissance',main="Graphique 1 : Évolution du taux de croissance \n de l'indice de production industrielle", col="blue")
mtext("Source : taux calculé à partir de l’indice de production industrielle de la France en euro \n provenant du site de la Réserve Fédéral de la banque de Saint Louis (FRED).  
", side=1, line=4, adj=1, cex=0.8)
plot(serie_petrole,xlab='Année',ylab='Taux inflation pétrole',main="Graphique 2 : Évolution du taux d'inflation \n du pétrole", col="blue")
mtext("Source : taux calculé à partir du prix du pétrole en euro par tonne importé par la France        \n provenant du site du Ministère de la Transition Ecologique et de la Cohésion des Territoires.  
", side=1, line=4, adj=1, cex=0.8)
plot(serie_gaz,xlab='Année',ylab='Taux inflation gaz naturel',main="Graphique 3 : Évolution du taux d'inflation \n du gaz naturel", col="blue")
mtext("Source : taux calculé à partir du prix spot du gaz naturel en France en euro par mégawatheure\n provenant du site du Ministère de la Transition Ecologique et de la Cohésion des Territoires.  
", side=1, line=4, adj=1, cex=0.8)

# 2.2- Etude de stationarité des séries
test_adf_pindust <- adf.test(serie_pindust,alternative="stationary")
print(test_adf_pindust)

test_adf_petrole <- adf.test(serie_petrole,alternative="stationary")
print(test_adf_petrole)

test_adf_gaz <- adf.test(serie_gaz,alternative="stationary")
print(test_adf_gaz)

#2.3- Etude de corrélation

series=cbind(serie_pindust,serie_petrole,serie_gaz)
correlation_matrice=cor(series,use="c")
print(correlation_matrice)

# *****************************--3-Modélisation ---****************************************

Serie=data.frame(serie_petrole,serie_gaz,serie_pindust)
View(Serie)

#3.1- Ordre du modèle
ordre_selection <- VARselect(Serie, lag.max = 12, type = "const")
print(ordre_selection)
ordre_optimal=ordre_selection$selection
print(ordre_optimal)

#3.2- Estimation du modèle
var_estimation <- VAR(Serie, p =3, type = "const")
summary(var_estimation)



# *****************************--4-Tests du modèle---****************************************

# Sauvegarder les graphiques en format pdf

savepdf <- function(file, width=16, height=10)
  #savepdf <- function(file, width=11.43, height=16.51)
{
  dir.create(file.path("figures"), showWarnings = FALSE)
  fname <- paste("figures",.Platform$file.sep, file,".pdf",sep="")
  pdf(fname, width=width/2.54, height=height/2.54,
      pointsize=10)
  par(mgp=c(2.2,0.45,0), tcl=-0.4, mar=c(3.3,3.6,1.1,1.1*3))
}

uhat <- resid(var_estimation4)

# Quelques graphiques sur les résidus
# line,histogrammes et fonction de répartition empirique (density),
# acf et pacf des résidus, acf et pacf des résidus au carré
names_var <- colnames(uhat)
windows(width = 15, height = 7)
par(mfrow = c(3,2))
ylimhist <- matrix(c(0, 0.25, 0, 0.07, 0, 0.25),byrow = TRUE, nrow=3)

# Graphique (dans une boucle)
nresid <- dim(uhat)[2]
for (j in 1:nresid){
  residj  <- ts(uhat[,j],start=c(2011,2),frequency=12)
  residj2 <- residj^2
  acfj    <- acf(residj,plot = F, lag.max=25)
  pacfj   <- pacf(residj,plot = F,lag.max=25)
  acf2j   <- acf(residj2,plot = F, lag.max=25)
  acf2j   <- acf(residj2,plot = F, lag.max=25)
  
  # Les graphiques
  #par(mfrow = c(3,2))
  #nf <- layout(matrix(c(1:(2*3)),nrow = 3, byrow=TRUE), widths=c(5,5,5), heights=c(2,2,2), TRUE)
  #nf <- layout(matrix(c(1,2,3,4,5,6),nrow = 3, byrow=TRUE))
  
  # On produit l'histogramme pour residu
  filename <- paste(paste0("Diag_",names_var[j]))
  savepdf(filename)
  nf <- layout(matrix(c(1:(2*3)),nrow = 3, byrow=TRUE), widths=c(5,5), heights=c(2,2,2), TRUE)
  
  hist_noplot <- hist(residj,plot = F)
  # ylim_hist   <- range(hist_noplot$density)
  ylim_hist   <- ylimhist[j,]
  print(ylim_hist)
  
  #ylim_hist   <-c(0,0.05)
  
  plot(residj,type='l',col='black',ylab="", main="Résidus", xlab="")
  hist(residj,freq=FALSE,xlab="",ylab="", ylim = ylim_hist,main = "Hist de la fonction de répart empirique des résidus.")
  lines(density(residj), col = "blue")
  stats::acf(coredata(residj), lag.max=25, main="ACF des résidus",xlab="",ylab="ACF des résidus")
  stats::pacf(coredata(residj),lag.max=25, main="PACF des résidus",xlab="",ylab="PACF des résidus")
  stats::acf(coredata(residj), lag.max=25, main="ACF des résidus au carré",xlab="",ylab="ACF résidus au carré")
  stats::pacf(coredata(residj),lag.max=25, main="PACF des résidus au carré",xlab="",ylab="PACF résidus au carré")
  dev.off()
}


# *****************************--5-Analyse Impact ---****************************************


# 5.1- Fonctions de réponse au choc #######

## 5.1.1- IRF avec décomposition de Cholesky

# a)Reponses pour choc taux inflation petrole


dev.new()
par(mfrow = c(1, 2))

reponse_choc_petrol1=irf(var_estimation, impulse = "serie_petrole", response =c("serie_petrole"),boot=TRUE, ortho=TRUE,n.ahead = 12)
plot(reponse_choc_petrol1, main = "Taux inflation pétrole ")
reponse_choc_petrol2=irf(var_estimation, impulse = "serie_petrole", response =c("serie_pindust"),boot=TRUE, ortho=TRUE,n.ahead = 12)
plot(reponse_choc_petrol2, main = "Taux de croissance indice production industrielle")

# b)reponses pour choc taux inflation gaz
par(mfrow = c(1, 2))

reponse_choc_gaz1=irf(var_estimation, impulse = "serie_gaz", response =c("serie_gaz"),boot=TRUE, ortho=TRUE,n.ahead = 12)
plot(reponse_choc_gaz1, main = "Taux inflation gaz")
reponse_choc_gaz2=irf(var_estimation, impulse = "serie_gaz", response =c("serie_pindust"),boot=TRUE, ortho=TRUE,n.ahead = 12)
plot(reponse_choc_gaz2, main = "Taux de croissance indice production industrielle")


## 5.1.2-IRF avec Blanchard Quah

## Modele estime
var_estimation4 <- VAR(Serie4, p =3, type = "const")
# # Utilisation restrictions de BQ
var_BQ<-BQ(var_estimation)
resum_var<-summary(var_BQ)
resum_var$B
## IRF avec BQ

irf1<-irf(var_BQ, impulse = "serie_petrole", response ="serie_pindust",boot=TRUE, ortho=TRUE,cumulative=FALSE,n.ahead = 40)
plot(irf1)
irf2<-irf(var_BQ, impulse = "serie_gaz", response ="serie_pindust",boot=TRUE, ortho=TRUE,cumulative=FALSE,n.ahead = 40)
plot(irf2)



# 5.2- Décomposition de variance #####

# 5.2.1- Décomposition de variance avec Decomposition de Cholesky
var_decomposition1 <- fevd(var_estimation, n.ahead = 10,ortho=TRUE)

# Afficher les résultats
print(var_decomposition1$serie_pindust)
print(var_decomposition1$serie_petrole)
print(var_decomposition1$serie_gaz)
base2=read_excel("Base_FEVD_Cholesky.xlsx")
library(ggplot2)
library(tidyr)
data_long <- pivot_longer(
  base2, 
  cols = c(`Taux_production_industrielle`, 
           `Taux_inflation_petrole`, 
           `Taux_inflation_gaz`),
  names_to = "Séries",
  values_to = "Chocs")
  # Créer le graphique en barres
ggplot(data_long, aes(x = Periode, y = Chocs, fill = Séries)) +
    geom_bar(stat = "identity", position = "dodge") +scale_x_continuous(breaks = 1:10) +
    labs(title = "Graphique 11: Décomposition de variance avec Cholesky",
         x = "Période",
         y = "Chocs",
         fill = "Séries") +
    theme_minimal()


# 5.2.2- Décomposition de variance avec Blanchard et Quah
var_decomposition2 <- fevd(svar_BQ, n.ahead = 10,ortho=TRUE)
# Afficher les résultats
print(var_decomposition2$serie_pindust)

# Graphique
base3=read_excel("Base_FEVD_Blanchard_Quah.xlsx")
data_long <- pivot_longer(
  base3, 
  cols = c(`Taux_production_industrielle`, 
           `Taux_inflation_petrole`, 
           `Taux_inflation_gaz`),
  names_to = "Séries",
  values_to = "Chocs")
# Créer le graphique en barres
ggplot(data_long, aes(x = Periode, y = Chocs, fill = Séries)) +
  geom_bar(stat = "identity", position = "dodge") +scale_x_continuous(breaks = 1:10) +
  labs(title = "Graphique 12: Décomposition de variance avec Blanchard Quah",
       x = "Période",
       y = "Chocs",
       fill = "Séries") +
  theme_minimal()

# 5.3- Decomposition historique des chocs #####

### 5.3.1- Creation des fonctions 
VARhd <- function(Estimation){
  
  ## make X and Y
  nlag    <- Estimation$p   # number of lags
  DATA    <- Estimation$y   # data
  QQ      <- VARmakexy(DATA,nlag,1)
  
  
  ## Retrieve and initialize variables 
  invA    <- t(chol(as.matrix(summary(Estimation)$covres)))   # inverse of the A matrix
  Fcomp   <- companionmatrix(Estimation)                      # Companion matrix
  
  #det     <- c_case                                          # constant and/or trends
  F1      <- t(QQ$Ft)                                         # make comparable to notes
  eps     <- ginv(invA) %*% t(residuals(Estimation))          # structural errors 
  nvar    <- Estimation$K                                     # number of endogenous variables
  nvarXeq <- nvar * nlag                                      # number of lagged endogenous per equation
  nvar_ex <- 0                                                # number of exogenous (excluding constant and trend)
  Y       <- QQ$Y                                             # left-hand side
  #X       <- QQ$X[,(1+det):(nvarXeq+det)]                    # right-hand side (no exogenous)
  n_obs     <- nrow(Y)                                         # number of observations
  
  
  ## Compute historical decompositions
  
  # Contribution of each shock
  invA_big <- matrix(0,nvarXeq,nvar)
  invA_big[1:nvar,] <- invA
  Icomp <- cbind(diag(nvar), matrix(0,nvar,(nlag-1)*nvar))
  HDshock_big <- array(0, dim=c(nlag*nvar,n_obs+1,nvar))
  HDshock <- array(0, dim=c(nvar,(n_obs+1),nvar))
  
  for (j in 1:nvar){  # for each variable
    eps_big <- matrix(0,nvar,(n_obs+1)) # matrix of shocks conformable with companion
    eps_big[j,2:ncol(eps_big)] <- eps[j,]
    for (i in 2:(n_obs+1)){
      HDshock_big[,i,j] <- invA_big %*% eps_big[,i] + Fcomp %*% HDshock_big[,(i-1),j]
      HDshock[,i,j] <-  Icomp %*% HDshock_big[,i,j]
    } 
    
  } 
  
  HD.shock <- array(0, dim=c((n_obs+nlag),nvar,nvar))   # [nobs x shock x var]
  
  for (i in 1:nvar){
    
    for (j in 1:nvar){
      HD.shock[,j,i] <- c(rep(NA,nlag), HDshock[i,(2:dim(HDshock)[2]),j])
    }
  }
  
  return(HD.shock)
  
}


VARmakexy <- function(DATA,lags,c_case){
  
  n_obs <- nrow(DATA)
  
  #Y matrix 
  Y <- DATA[(lags+1):nrow(DATA),]
  Y <- DATA[-c(1:lags),]
  
  #X-matrix 
  if (c_case==0){
    X <- NA
    for (jj in 0:(lags-1)){
      X <- rbind(DATA[(jj+1):(n_obs-lags+jj),])
    } 
  } else if(c_case==1){ #constant
    X <- NA
    for (jj in 0:(lags-1)){
      X <- rbind(DATA[(jj+1):(n_obs-lags+jj),])
    }
    X <- cbind(matrix(1,(n_obs-lags),1), X) 
  } else if(c_case==2){ # time trend and constant
    X <- NA
    for (jj in 0:(lags-1)){
      X <- rbind(DATA[(jj+1):(n_obs-lags+jj),])
    }
    trend <- c(1:nrow(X))
    X <-cbind(matrix(1,(n_obs-lags),1), t(trend))
  }
  A <- (t(X) %*% as.matrix(X)) 
  B <- (as.matrix(t(X)) %*% as.matrix(Y))
  
  Ft <- ginv(A) %*% B
  
  retu <- list(X=X,Y=Y, Ft=Ft)
  return(retu)
}

companionmatrix <- function (x) 
{
  if (!(class(x) == "varest")) {
    stop("\nPlease provide an object of class 'varest', generated by 'VAR()'.\n")
  }
  K <- x$K
  p <- x$p
  A <- unlist(Acoef(x))
  companion <- matrix(0, nrow = K * p, ncol = K * p)
  companion[1:K, 1:(K * p)] <- A
  if (p > 1) {
    j <- 0
    for (i in (K + 1):(K * p)) {
      j <- j + 1
      companion[i, j] <- 1
    }
  }
  return(companion)
}


VARhdplot <- function(HD.shock,shocks_name,timeindex,Estimation){
  
  # Initialize HD matrix
  nsteps   <- dim(HD.shock)[1]
  nvars    <- dim(HD.shock)[2]
  nshocks  <- dim(HD.shock)[3]
  
  for (ii in 1:nvars){
    filename  <- paste(paste0("DecompHistvar",as.character(ii)))
    datai     <- Estimation$y[,ii]
    
    HDshockii <- na.omit(HD.shock[,,ii])
    squeezeHD <- matlab2r::squeeze(HDshockii)
    
    # Separate positive and negative values
    data_pos <- squeezeHD
    data_pos[data_pos < 0] <- 0
    
    data_neg <- squeezeHD
    data_neg[data_neg > 0] <- 0
    
    #Générer une palette de couleurs sur la base du nombre de colonnes
    # de la matrice
    n_colors <- ncol(squeezeHD)
    colors   <- rainbow(n_colors)
    
    range_shock <- range(squeezeHD) + c(-6,6) # à ajuster si besoin.
    
    
    # Plot the positive values
    savepdf(filename)
    bar_positions <- barplot(t(data_pos), beside = FALSE, col = colors,
                             main = "Decomposition historique", 
                             xlab = "", ylab = "",   ylim = range_shock,cex.main=0.8)
    
    # Plot the negative values
    barplot(t(data_neg), beside = FALSE, col = colors, ylim = range_shock, add = TRUE)
    
    row_sums <- rowSums(squeezeHD)
    
    
    lines(bar_positions,datai[-c(1:Estimation$p)],type='l',col='orange', lwd=2)
    
    # This part adds year labels on the x-axis
    year       <- unique(floor(timeindex))
    x_axis     <- year[seq(1,length(year),by=1)]
    x_axis_pos <- seq(from=min(bar_positions), to= max(bar_positions), length.out= length(year))
    selec_pos  <- x_axis_pos[seq(1,length(year),by=1)]
    axis(1, at = selec_pos, labels = x_axis)
    box(which = "plot", bty = "l") # joindre l'axe des abscisses et l'axe des ordonnées
    legend("topleft",legend = c(shocks_name, 'donnees'),fill= c(colors,'orange'))
    
    dev.off()
    
    
  }
}

## 5.3.2- Utilisation des fonctions
# Nom des chocs
shock_names <- c("Choc Pétrole", "Choc Gaz","Choc Production")

# utilisation de la fonction 1
HD_shock<-VARhd(var_estimation)

#  Ajuster l'indice temps

mytimeindex <- c(0:(length(serie_pindust)-1))/12 + 2011


# Utilisation de la fonction 4
VARhdplot(HD_shock,shock_names,mytimeindex,var_estimation)

