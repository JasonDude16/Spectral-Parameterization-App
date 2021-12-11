no_alpha_fooof_settings <- readRDS("./data/no_alpha_fooof_settings.RDS")

EC32 <- readRDS("./data/rbl_adol_EC_32.RDS")
EC64 <- readRDS("./data/rbl_adol_EC_64.RDS")
EO32 <- readRDS("./data/rbl_adol_EO_32.RDS")
EO64 <- readRDS("./data/rbl_adol_EO_64.RDS")

NA_EC32 <- readRDS("./data/no_alpha_EC_32.RDS")
NA_EC64 <- readRDS("./data/no_alpha_EC_64.RDS")
NA_EO32 <- readRDS("./data/no_alpha_EO_32.RDS")
NA_EO64 <- readRDS("./data/no_alpha_EO_64.RDS")

names(EC32) <- sub("_[0-9]", "", names(EC32))
names(EC64) <- sub("_[0-9]", "", names(EC64))
names(EO32) <- sub("_[0-9]", "", names(EO32))
names(EO64) <- sub("_[0-9]", "", names(EO64))

df <- NULL
df$EC$`32` <- EC32
df$EC$`64` <- EC64
df$EO$`32` <- EO32
df$EO$`64` <- EO64

no_alpha <- NULL
no_alpha$EC$`32` <- NA_EC32
no_alpha$EC$`64` <- NA_EC64
no_alpha$EO$`32` <- NA_EO32
no_alpha$EO$`64` <- NA_EO64