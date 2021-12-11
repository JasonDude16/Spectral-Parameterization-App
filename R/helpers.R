library(gghighlight)

psd_facet_plot <- function(df, freq_low, freq_high, log_freq, log_power, all_elec, elec){
  
  df_all <- df$spectrum %>% 
            as.data.frame() %>% 
            mutate(freq = as.numeric(row.names(.))) %>% 
            dplyr::filter(freq > freq_low, freq < freq_high) %>% 
            tidyr::pivot_longer(., cols = -freq) %>% 
            mutate(Electrode = name,
            power = value)
  
  if (log_freq) {
    df_all$freq <- log(df_all$freq)
  }
  
  if (log_power) {
    df_all$power <- log(df_all$power)
  }
  
  p1 <- df_all %>% 
        ggplot(aes(x = freq, y = power, group = Electrode, col = Electrode)) +
        geom_line() + 
        xlab("Frequency") +
        ylab("Power")
  
  
  if (all_elec) {
    p1 <- p1 + gghighlight()
  }
  
  p2 <- p1 + facet_wrap(~ Electrode, nrow = 2) + theme_classic()
  
  return(p2)
  
}


# ---------------------------------------------------------------------------------------------


psd_all_plot <- function(df, freq_low, freq_high, log_freq, log_power, all_elec, elec){
  
  df_all <- df$spectrum %>% 
            as.data.frame() %>% 
            mutate(freq = as.numeric(row.names(.))) %>% 
            dplyr::filter(freq > freq_low, freq < freq_high) %>% 
            tidyr::pivot_longer(., cols = -freq) %>% 
            mutate(Electrode = name,
                   power = value)
  
  df_avg <- df$spectrum %>%
            as.data.frame() %>%
            mutate(freq = as.numeric(row.names(.))) %>%
            mutate(Avg = rowMeans(.[-ncol(.)]),
                   Electrode = "Avg") %>%
            filter(freq > freq_low, freq < freq_high) %>% 
            select(freq, Avg, Electrode)
  
  if (log_freq) {
    df_all$freq <- log(df_all$freq)
    df_avg$freq <- log(df_avg$freq)
  }
  
  if (log_power) {
    df_all$power <- log(df_all$power)
    df_avg$Avg <- log(df_avg$Avg)
  }
  
  ggplot() +
    geom_line(data = df_avg, mapping = aes(x = freq, y = Avg, group = Electrode), col = "black", size = 1.2) +
    geom_line(data = df_all, mapping = aes(x = freq, y = power, group = Electrode), col = "gray", alpha = .7) +
    xlab("Frequency") +
    ylab("Power") +
    ggtitle("Average of Electrodes") + 
    theme_classic()
  
}
