# Exam Prep Guide: Factor Analysis and Hierarchical Clustering

This guide is designed for fast, exam-focused preparation on:

- Factor Analysis (FA)
- Hierarchical Clustering (HC)

It includes core theory, formulas, R code templates, interpretation language, common questions, and a short revision strategy.

## 1) Factor Analysis (FA)

### What it does

Factor analysis reduces many correlated observed variables into a smaller number of latent (hidden) factors.

Example idea: instead of 15 questionnaire items, FA may reveal 5 latent dimensions.

### Core model

For variable $x_j$:

$$
x_j = \lambda_{j1}F_1 + \lambda_{j2}F_2 + \cdots + \lambda_{jm}F_m + \epsilon_j
$$

- $\lambda_{jk}$: loading of variable $j$ on factor $k$
- $F_k$: latent factor
- $\epsilon_j$: unique/error term

### Key terms to memorize

- Loadings: correlation-like relation between variable and factor
- Communality ($h^2$): variance of variable explained by common factors
- Uniqueness ($u^2$): unexplained (specific + error) variance
- Rotation (varimax): makes factors easier to interpret

### Assumptions (typical exam points)

- Variables are reasonably correlated
- Sample size is adequate
- Linear relationships among variables
- Multivariate normality is often preferred for ML extraction

### How to choose number of factors

- Scree plot elbow method
- Kaiser criterion: keep factors with eigenvalue $> 1$
- Interpretability of factor structure
- Cumulative explained variance

### Standard R workflow

```r
library(psych)

# Keep numeric features and standardize
X <- scale(df_numeric)

# Scree / eigenvalues
eigs <- eigen(cor(X))$values
plot(eigs, type = "b", pch = 19,
     xlab = "Component Number", ylab = "Eigenvalue",
     main = "Scree Plot")
abline(h = 1, col = "red", lty = 2)

# Fit FA
fa_fit <- fa(X, nfactors = 2, rotate = "varimax", fm = "ml")

# Loadings and explained variance
print(fa_fit$loadings, cutoff = 0.30)
fa_fit$Vaccounted
```

### How to interpret quickly

- High absolute loadings (for example $|\lambda| > 0.6$) identify defining variables of a factor.
- Name factors using the common meaning of high-loading variables.
- Report variance explained by each retained factor.

### Ready-to-write exam sentence

"After standardization, ML factor analysis with varimax rotation retained $k$ factors based on scree and eigenvalue criteria. Variables with high absolute loadings defined each latent construct, and the retained factors explained the major proportion of variance."

## 2) Hierarchical Clustering (HC)

### What it does

Hierarchical clustering groups observations based on pairwise distances and builds a tree-like structure (dendrogram).

### Agglomerative HC process

1. Start with each observation as its own cluster.
2. Merge the two closest clusters.
3. Repeat until one cluster remains.

### Linkage methods you must know

- Single linkage: minimum distance between clusters
- Complete linkage: maximum distance between clusters

Single linkage may create chaining effects. Complete linkage usually creates tighter, compact clusters.

### Distance metric

Most common in exam practice: Euclidean distance after standardization.

### Standard R workflow

```r
# Standardize
X <- scale(df_numeric)

# Distance matrix
d <- dist(X)

# Hierarchical clustering
hc_single <- hclust(d, method = "single")
hc_complete <- hclust(d, method = "complete")

# Dendrograms
par(mfrow = c(1, 2))
plot(hc_single, main = "Single Linkage", xlab = "", sub = "")
plot(hc_complete, main = "Complete Linkage", xlab = "", sub = "")

# Extract clusters
cl_single <- cutree(hc_single, k = 4)
cl_complete <- cutree(hc_complete, k = 4)

table(cl_single)
table(cl_complete)
```

### How to interpret dendrogram

- Height of merge = dissimilarity at which clusters merge.
- Large vertical jumps suggest natural separation.
- Choose $k$ by cutting tree at a suitable height.

### Ready-to-write exam sentence

"Hierarchical clustering on standardized variables was performed using single and complete linkage. The complete linkage dendrogram showed more compact and better-separated groups, while single linkage exhibited chaining."

## 3) FA vs PCA (frequently asked)

- PCA: transforms observed variables into linear components to maximize total variance explained; no explicit latent-error model.
- FA: models shared covariance using latent factors plus unique error terms.

Short answer line:
"PCA is a variance-reduction transformation, whereas FA is a latent-variable model for common variance."

## 4) High-Probability Viva/Exam Questions

1. Why standardize before FA/HC?
2. Why use rotation in FA? Why varimax?
3. How is number of factors selected?
4. What does a loading of 0.8 mean?
5. Difference between communality and uniqueness?
6. Difference between single and complete linkage?
7. How do you decide number of clusters from a dendrogram?
8. Why can single linkage produce chaining?

## 5) Mistakes to Avoid

- Not scaling data when variables are on different units.
- Interpreting tiny loadings as meaningful.
- Selecting too many factors without interpretability.
- Reporting plots without explanation.
- Declaring clusters without mentioning cut level/$k$.

## 6) Quick Practical Template (USArrests Style)

```r
library(psych)

# Data
X <- scale(USArrests)

# FA
eigs <- eigen(cor(X))$values
plot(eigs, type = "b", pch = 19)
abline(h = 1, col = "red", lty = 2)
fa_us <- fa(X, nfactors = 2, rotate = "varimax", fm = "ml")
print(fa_us$loadings, cutoff = 0.30)

# HC
d <- dist(X)
hc_s <- hclust(d, method = "single")
hc_c <- hclust(d, method = "complete")

par(mfrow = c(1, 2))
plot(hc_s, cex = 0.6, main = "USArrests Single")
plot(hc_c, cex = 0.6, main = "USArrests Complete")

clusters <- data.frame(
  State = rownames(USArrests),
  single = cutree(hc_s, k = 4),
  complete = cutree(hc_c, k = 4)
)
head(clusters)
```

## 7) One-Day Revision Plan

1. 1 hour: FA theory + assumptions + formulas
2. 1 hour: FA coding and interpretation (scree + loadings)
3. 1 hour: HC theory + linkage differences
4. 1 hour: HC coding + dendrogram interpretation
5. 1 hour: write 3 exam-style answers from memory
6. 1 hour: revise weak points + oral practice

## 8) Final 5-Minute Exam Checklist

- Mentioned preprocessing (`scale`) clearly?
- Included and interpreted scree/dendrogram?
- Justified number of factors/clusters?
- Explained results in words, not only tables?
- Compared single vs complete linkage?

---

Prepared for: fast revision and direct exam writing.