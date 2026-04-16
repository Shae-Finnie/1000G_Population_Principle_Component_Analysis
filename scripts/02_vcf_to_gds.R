library(gdsfmt)
library(SNPRelate)

# Paths
processed_dir <- "data/processed"
results_dir   <- "results"
dir.create(results_dir, showWarnings = FALSE)

# Convert Chr1 VCF to GDS
snpgdsVCF2GDS(
  file.path(processed_dir, "chr1_biallelic_snps_filtered_maf.vcf.gz"),
  file.path(processed_dir, "chr1_biallelic_snps_filtered_maf.gds")
)

# Convert Chr10 VCF to GDS
snpgdsVCF2GDS(
  file.path(processed_dir, "chr10_biallelic_snps_filtered_maf.vcf.gz"),
  file.path(processed_dir, "chr10_biallelic_snps_filtered_maf.gds")
)

# Run PCA on Chr1
chr1_gds <- snpgdsOpen(file.path(processed_dir, "chr1_biallelic_snps_filtered_maf.gds"))
pca_chr1 <- snpgdsPCA(chr1_gds, num.thread = 8)
saveRDS(pca_chr1, file.path(results_dir, "pca_chr1.rds"))
snpgdsClose(chr1_gds)

# Run PCA on Chr10
chr10_gds <- snpgdsOpen(file.path(processed_dir, "chr10_biallelic_snps_filtered_maf.gds"))
pca_chr10 <- snpgdsPCA(chr10_gds, num.thread = 8)
saveRDS(pca_chr10, file.path(results_dir, "pca_chr10.rds"))
snpgdsClose(chr10_gds)

cat("GDS conversion and PCA complete\n")
