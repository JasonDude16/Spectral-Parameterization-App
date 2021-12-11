overview_top <-
"
Spectral parameterization is an automated method for parameterizing neural power spectra to 
disentangle periodic and aperiodic spectral features. This algorithm fits components of power 
spectral densities (PSDs) in an efficient and physiologically-informed manner, while remaining 
agnostic to predefined canonical frequency bands. <i>Aperiodic activity</i> refers to the arrhythmic 
component of neural field data, such as the EEG signal, which contributes power across all 
frequencies (He, 2014; Freeman & Zhai, 2009). <i>Periodic activity</i> refers to the rhythmic component 
of the EEG signal that rises above the aperiodic exponent, indexing putative neural oscillations, 
visible as peaks in the power spectrum (Buzsaki et al, 2013).
"

mod_param <- 
  data.frame(Setting = c("peak_width_limits", "max_n_peaks", "peak_threshold", "min_peak_height", "aperiodic_mode"),
             Units = c("Hz", "", "Standard deviations", "Power", ""),
             Default = c("[0.5, 12]", "infinite", "2", "0", "‘fixed’"),
             Description = c("Limits on the bandwidth of extracted peaks.",
                             "Maximum number of peaks that can be extracted.",
                             "Threshold above which a data point must pass to be considered a candidate peak.",
                             "Minimum height, above aperiodic fit, that a peak must have to be extracted in the initial fit stage.",
                             "The mode for fitting the aperiodic component, i.e., fitting with or without a ‘knee’ parameter."))

row.names(mod_param) <- NULL
mod_param_table <- htmlTable::htmlTable(mod_param, 
                                        rnames = FALSE, 
                                        align = "l", 
                                        caption = shiny::h4(" Model Parameters"), 
                                        css.cell = "padding-left: .5em; padding-right: 2em;", 
                                        useViewer = F)

aperiodic_text <- 
"
<i>aperiodic_mode</i>: whether to fit the aperiodic signal with a 'knee' (default = ‘fixed’). 
We recommend that a user visually inspect spectral data across a broad frequency range to see if 
the putative aperiodic signal appears approximately linear. The ‘fixed’ mode (k = 0) is the default 
because the PSD is likely approximately linear over smaller frequency ranges (e.g., 3-35 Hz). 
Fitting with a knee may perform sub-optimally in ambiguous cases (where the data may or may not 
have a knee), or if no knee is present. The ‘fixed’ mode will not fit the data well if there is a 
clear knee in the power spectrum; in this case, use the ‘knee’ mode.
<br>
"

example_report <- 
"The specparam algorithm (version X.X.X) was used to parameterize EEG power spectra. Algorithm 
settings were set as: peak width limits: XX; max number of peaks: XX; minimum peak height: XX; 
peak threshold: XX; and aperiodic mode: XX. Power spectra were parameterized across the frequency 
range XX to XX Hz."