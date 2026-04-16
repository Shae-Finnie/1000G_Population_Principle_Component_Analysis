library(dplyr)
library(ggplot2)
library(cowplot)
library(viridis)
library(patchwork)
library(ggrepel)

# Paths
results_dir <- "results"
figures_dir <- "results/figures"
dir.create(figures_dir, showWarnings = FALSE)

# Load PCA results and population data
pca_chr1        <- readRDS(file.path(results_dir, "pca_chr1.rds"))
pca_chr10       <- readRDS(file.path(results_dir, "pca_chr10.rds"))
population_data <- read.csv("data/raw/Populations.tsv", sep = "\t", header = TRUE)

# Population colors
population_colors <- c(
  setNames(viridis::turbo(4, begin = 0.0, end = 0.2), c("CLM", "MXL", "PEL", "PUR")),
  setNames(viridis::turbo(5, begin = 0.2, end = 0.4), c("CDX", "CHB", "CHS", "JPT", "KHV")),
  setNames(viridis::turbo(5, begin = 0.4, end = 0.6), c("CEU", "FIN", "GBR", "IBS", "TSI")),
  setNames(viridis::turbo(5, begin = 0.6, end = 0.8), c("BEB", "GIH", "ITU", "PJL", "STU")),
  setNames(viridis::turbo(7, begin = 0.8, end = 1.0), c("ACB", "ASW", "ESN", "GWD", "LWK", "MSL", "YRI"))
)

# Reusable axis limits
PCA_x_limits <- scale_x_continuous(
  limits = c(-0.015, 0.035),
  labels = scales::number_format(accuracy = 0.001),
  breaks = seq(-0.015, 0.035, length.out = 4)
)

PCA_y_limits <- scale_y_continuous(
  limits = c(-0.03, 0.04),
  labels = scales::number_format(accuracy = 0.001),
  breaks = seq(-0.03, 0.04, length.out = 4)
)

# Reusable theme for superpop scatter plots
PCA_plot_theme <- theme(
  legend.position = "none",
  axis.text.x     = element_text(size = 5.5),
  axis.text.y     = element_text(size = 5.5),
  axis.title.x    = element_text(size = 8, face = "bold"),
  axis.title.y    = element_text(size = 8, face = "bold"),
  plot.title      = element_text(hjust = 0.5, size = 10)
)

# Build PCA dataframe helper
build_pca_df <- function(pca, pop_data) {
  df <- data.frame(
    SampleID = pca$sample.id,
    PC1      = pca$eigenvect[, 1],
    PC2      = pca$eigenvect[, 2]
  )
  df <- merge(df, pop_data, by.x = "SampleID", by.y = "Sample.name")
  pop_levels <- c("CLM","MXL","PEL","PUR",
                  "CDX","CHB","CHS","JPT","KHV",
                  "CEU","FIN","GBR","IBS","TSI",
                  "BEB","GIH","ITU","PJL","STU",
                  "ACB","ASW","ESN","GWD","LWK","MSL","YRI")
  df$Population.code <- factor(df$Population.code, levels = pop_levels)
  df <- df[!is.na(df$Population.code), ]
  df
}

# Build superpopulation scatter plots
build_superpop_plots <- function(pca_df, chr_label) {
  superpops <- list(
    AMR = list(code = "AMR", label = "Admixed Americans (AMR)"),
    EAS = list(code = "EAS", label = "East Asians (EAS)"),
    EUR = list(code = "EUR", label = "Europeans (EUR)"),
    SAS = list(code = "SAS", label = "South Asians (SAS)"),
    AFR = list(code = "AFR", label = "Africans (AFR)")
  )
  
  whole_plot <- ggplot(pca_df, aes(x = PC1, y = PC2, color = Population.code)) +
    geom_point(size = 1.5, alpha = 0.6) +
    labs(title = "All Populations", x = "PC1", y = "PC2", color = "Population Codes") +
    theme_cowplot() +
    scale_color_manual(values = population_colors) +
    PCA_x_limits + PCA_y_limits +
    theme(
      legend.title    = element_text(size = 9, face = "bold", hjust = 0.5),
      legend.text     = element_text(size = 7, face = "bold"),
      legend.position = "right",
      axis.text.x     = element_text(size = 6),
      axis.text.y     = element_text(size = 6),
      axis.title.x    = element_text(size = 8, face = "bold"),
      axis.title.y    = element_text(size = 8, face = "bold"),
      plot.title      = element_text(hjust = 0.5, size = 10)
    )
  
  sp_plots <- lapply(superpops, function(sp) {
    df_sub <- pca_df %>% filter(Superpopulation.code == sp$code)
    ggplot(df_sub, aes(x = PC1, y = PC2, color = Population.code)) +
      geom_point(size = 2, alpha = 0.6) +
      labs(title = sp$label, x = "PC1", y = "PC2") +
      theme_cowplot() +
      scale_color_manual(values = population_colors) +
      PCA_x_limits + PCA_y_limits +
      PCA_plot_theme
  })
  
  combined <- (whole_plot + sp_plots$AMR + sp_plots$EAS) /
    (sp_plots$EUR + sp_plots$SAS + sp_plots$AFR) +
    plot_layout(guides = "collect") +
    plot_annotation(
      title = paste("Population PCAs for Chromosome", chr_label),
      theme = theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold"))
    )
  
  list(whole = whole_plot, superpops = sp_plots, combined = combined)
}

# Build mean PCA plots
build_mean_plots <- function(pca_df, chr_label) {
  superpops <- list(
    AMR = list(code = "AMR", label = "Admixed American (AMR)"),
    EAS = list(code = "EAS", label = "East Asians (EAS)"),
    EUR = list(code = "EUR", label = "European (EUR)"),
    SAS = list(code = "SAS", label = "South Asian (SAS)"),
    AFR = list(code = "AFR", label = "Africans (AFR)")
  )
  
  white_theme <- theme(
    legend.position  = "none",
    plot.background  = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    axis.text.x      = element_text(size = 8),
    axis.text.y      = element_text(size = 8),
    axis.title.x     = element_text(size = 10, face = "bold"),
    axis.title.y     = element_text(size = 10, face = "bold"),
    plot.title       = element_text(hjust = 0.5, size = 12, face = "bold")
  )
  
  repel_lines <- geom_text_repel(
    aes(label = Population.code),
    color              = "black",
    size               = 3,
    max.overlaps       = Inf,
    max.time           = 2,
    min.segment.length = 0,
    segment.size       = 0.2,
    box.padding        = 0.5,
    point.padding      = 0.5,
    force              = 2
  )
  
  repel_no_lines <- geom_text_repel(
    aes(label = Population.code),
    color         = "black",
    size          = 3,
    max.overlaps  = Inf,
    max.time      = 2,
    segment.color = "transparent",
    box.padding   = 0.5,
    point.padding = 0.5,
    force         = 2
  )
  
  # Compute whole population means
  means_all <- pca_df %>%
    group_by(Population.code) %>%
    summarise(PC1_mean = mean(PC1, na.rm = TRUE),
              PC2_mean = mean(PC2, na.rm = TRUE))
  
  whole_mean <- ggplot(means_all, aes(x = PC1_mean, y = PC2_mean, color = Population.code)) +
    geom_point(size = 3, alpha = 0.8) +
    repel_lines +
    labs(title = "All Populations", x = "PC1", y = "PC2") +
    theme_cowplot() +
    scale_color_manual(values = population_colors) +
    PCA_x_limits + PCA_y_limits +
    white_theme
  
  # Per superpopulation means with zoomed axes
  sp_mean_plots <- lapply(superpops, function(sp) {
    df_sub    <- pca_df %>% filter(Superpopulation.code == sp$code)
    means_sub <- df_sub %>%
      group_by(Population.code) %>%
      summarise(PC1_mean = mean(PC1, na.rm = TRUE),
                PC2_mean = mean(PC2, na.rm = TRUE))
    
    ggplot(means_sub, aes(x = PC1_mean, y = PC2_mean, color = Population.code)) +
      geom_point(size = 3, alpha = 0.8) +
      repel_no_lines +
      labs(title = sp$label, x = "PC1", y = "PC2") +
      theme_cowplot() +
      scale_color_manual(values = population_colors) +
      white_theme
  })
  
  # Combined means plot
  combined_means <- (whole_mean + sp_mean_plots$AMR + sp_mean_plots$EAS) /
    (sp_mean_plots$EUR + sp_mean_plots$SAS + sp_mean_plots$AFR) +
    plot_annotation(
      title = paste("Mean Population PCAs of Chromosome", chr_label),
      theme = theme(
        plot.title      = element_text(hjust = 0.5, size = 16, face = "bold"),
        plot.background = element_rect(fill = "white", color = NA)
      )
    )
  
  combined_means
}

# Chr1 plots
pca_df_chr1  <- build_pca_df(pca_chr1, population_data)
chr1_plots   <- build_superpop_plots(pca_df_chr1, "1")
chr1_mean    <- build_mean_plots(pca_df_chr1, "1")

# Chr10 plots
pca_df_chr10 <- build_pca_df(pca_chr10, population_data)
chr10_plots  <- build_superpop_plots(pca_df_chr10, "10")
chr10_mean   <- build_mean_plots(pca_df_chr10, "10")

# Save figures
ggsave(file.path(figures_dir, "chr1_pca_combined.png"),  chr1_plots$combined, width = 12, height = 8, dpi = 300)
ggsave(file.path(figures_dir, "chr10_pca_combined.png"), chr10_plots$combined, width = 12, height = 8, dpi = 300)
ggsave(file.path(figures_dir, "chr1_pca_means.png"),  chr1_mean,  width = 12, height = 8, dpi = 300, bg = "white")
ggsave(file.path(figures_dir, "chr10_pca_means.png"), chr10_mean, width = 12, height = 8, dpi = 300, bg = "white")

cat("PCA plots saved to results/figures\n")
