# Project Overview (WIP)

This project explores population genetic structure using whole genome sequencing data from the 1000 Genomes Project (NHLBI high-coverage resequencing, 3,202 samples across 26 populations). Starting from biallelic SNP VCF files for chromosomes 1 and 10, variants are filtered for common alleles (MAF > 1%) and converted to GDS format for analysis in R. Principal component analysis (PCA) is then performed to visualize genetic diversity across five continental superpopulations (African, Admixed American, East Asian, European, and South Asian), with both individual-level scatter plots and population mean plots generated for comparison. The project additionally calculates pairwise FST between populations to quantify genetic differentiation.

### Repository Structure 

```
├── data
│   ├── processed
│   └── raw
├── README.md
├── results
│   ├── figures
│   ├── pca_chr1.rds
│   └── pca_chr10.rds
└── scripts
    ├── 01_vcf_filter
    ├── 02_vcf_to_gds.R
    └── 03_pca_plotter.R
...
```

### Population Codes 

| Population | Code | Superpopulation | DNA Samples | Cell Cultures |
|---|---|---|---|---|
| African Ancestry in SW USA | ASW | AFR | 62 | 62 |
| African Caribbean in Barbados | ACB | AFR | 120 | 120 |
| Esan in Nigeria | ESN | AFR | 173 | 173 |
| Gambian in Western Division – Mandinka | GWD | AFR | 179 | 179 |
| Luhya in Webuye, Kenya | LWK | AFR | 120 | 120 |
| Mende in Sierra Leone | MSL | AFR | 128 | 128 |
| Yoruba in Ibadan, Nigeria | YRI | AFR | 120 | 120 |
| Colombian in Medellín, Colombia | CLM | AMR | 136 | 136 |
| Mexican Ancestry in Los Angeles CA, USA | MXL | AMR | 71 | 71 |
| Peruvian in Lima, Peru | PEL | AMR | 122 | 122 |
| Puerto Rican in Puerto Rico | PUR | AMR | 139 | 139 |
| Chinese Dai in Xishuangbanna, China | CDX | EAS | 102 | 102 |
| Han Chinese in Beijing, China | CHB | EAS | 120 | 120 |
| Han Chinese South | CHS | EAS | 163 | 163 |
| Japanese in Tokyo, Japan | JPT | EAS | 120 | 120 |
| Kinh in Ho Chi Minh City, Vietnam | KHV | EAS | 124 | 124 |
| British from England and Scotland | GBR | EUR | 100 | 100 |
| Finnish in Finland | FIN | EUR | 103 | 103 |
| Iberian Populations in Spain | IBS | EUR | 157 | 157 |
| Toscani in Italia | TSI | EUR | 114 | 114 |
| Bengali in Bangladesh | BEB | SAS | 144 | 144 |
| Gujarati Indians in Houston, Texas, USA | GIH | SAS | 109 | 109 |
| Indian Telugu in the U.K. | ITU | SAS | 118 | 118 |
| Punjabi in Lahore, Pakistan | PJL | SAS | 158 | 158 |
| Sri Lankan Tamil in the UK | STU | SAS | 128 | 128 |

## Whole Population PCA Plots Chromosome 1 

![Chr 1 Whole PCA](results/figures/chr1_pca_combined.png)

PCA of 3,202 individuals across 26 populations using common biallelic SNPs from chromosome 1. Each point represents one sample, coloured by population code. Superpopulation-level plots show within-group spread along PC1 and PC2.

## Whole Population PCA Plots Chromosome 10 

![Chr 10 Whole PCA](results/figures/chr10_pca_combined.png)

PCA of 3,202 individuals using common biallelic SNPs from chromosome 10. Population clustering patterns are broadly consistent with chromosome 1, supporting the robustness of the observed structure across different genomic regions.

## Mean Population PCA Plots Chromosome 1 

![Chr 1 Means PCA](results/figures/chr1_pca_means.png)

Mean PC1 and PC2 values per population for chromosome 1. Each point represents the centroid of one population, with zoomed axes per superpopulation to resolve fine-scale separation between closely related groups.

## Mean Population PCA Plots Chromosome 10 

![Chr 10 Means PCA](results/figures/chr10_pca_means.png)

Mean PC1 and PC2 values per population for chromosome 10. Superpopulation-level panels reveal subpopulation relationships consistent with those observed on chromosome 1, with minor differences in spread reflecting regional variation in linkage and diversity.

## Superpopulation FST Chromosome 1 

![Chr 10 Means PCA](results/figures/fst_chr1_heatmap.png)

Pairwise FST values between the five 1000 Genomes superpopulations (AFR, AMR, EAS, EUR, SAS) estimated from biallelic SNPs on Chromosome 1 using the Weir & Cockerham (1984) method. Color intensity reflects the degree of genetic differentiation, with darker (higher) values indicating greater divergence between population pairs. African populations (AFR) show the highest FST values relative to all other superpopulations, consistent with the out-of-Africa bottleneck and greater genetic diversity within AFR. Non-African superpopulations (AMR, EAS, EUR, SAS) exhibit comparatively lower pairwise FST, reflecting shared ancestral bottlenecks during dispersal. The diagonal is zero by definition (within-population comparison).

## Superpopulation FST Chromosome 10 

![Chr 10 Means PCA](results/figures/fst_chr10_heatmap.png)

## Sub Population  Chromosome 1

![Chr 10 Means PCA](results/figures/fst_chr1_subpop_heatmap.png)

Pairwise FST values between all 26 subpopulations from the 1000 Genomes Project estimated from biallelic SNPs on Chromosome 1 using the Weir & Cockerham (1984) method. Populations are grouped and ordered by superpopulation (AFR, AMR, EAS, EUR, SAS), allowing continental-level clustering patterns to be visualized alongside fine-scale subpopulation structure. Darker cells indicate higher genetic differentiation between pairs. African subpopulations (e.g., YRI, LWK, ESN, MSL, GWD, ASW, ACB) display elevated FST against all non-African subpopulations, with particularly high values observed between geographically and ancestrally distant pairs. Admixed populations such as ASW and ACB show intermediate FST values reflecting African and European ancestry. East Asian (e.g., CHB, CHS, CDX, KHV) and South Asian (e.g., GIH, PJL, BEB) subpopulations cluster with lower within-superpopulation FST, indicating close genetic affinity. The symmetric matrix has zeros along the diagonal.

## Sub Population Chromosome 10 

![Chr 10 Means PCA](results/figures/fst_chr10_subpop_heatmap.png)