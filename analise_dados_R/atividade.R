library(tidyverse)
library(lubridate)

setwd("D:/analise_dados/Analise-de-Dados/analise_dados_R/dados")

df_csv <- read_csv("sim_salvador_2023_processado.csv")

#1.1
df_csv <- df_csv %>%
  mutate(
    faixa_etaria = case_when(
      idade_anos >= 0 & idade_anos <= 12 ~ "Criança",
      idade_anos >= 13 & idade_anos <= 17 ~ "Adolescente",
      idade_anos >= 18 & idade_anos <= 59 ~ "Adulto",
      idade_anos >= 60 ~ "Idoso",
      TRUE ~ NA_character_  
    )
  )

glimpse(df_csv)

#1.2
resultado <- df_csv %>%
  count(faixa_etaria, sort=TRUE)
print(resultado)
View(resultado)

#1.2 Maneira Alternativa
resultado <- df_csv %>%
  group_by(faixa_etaria) %>%
  summarise(total_obitos = n()) %>%
  arrange(desc(total_obitos))
print(resultado)
View(resultado)

#2.1
df_csv <- df_csv %>%
  mutate(
    DTOBITO_dt = dmy(DTOBITO),
    mes = month(DTOBITO_dt),
    trimestre <- case_when(
      mes == 1 | mes == 2 | mes == 3 ~ "1 Trimestre",
      mes == 4 | mes == 5 | mes == 6 ~ "2 Trimestre",
      mes == 7 | mes == 8 | mes == 9 ~ "3 Trimestre",
      mes == 10 | mes == 11 | mes == 12 ~ "4 Trimestre",
      TRUE ~ NA_character_  
    )
  )

glimpse(df_csv)

#2.2
resultado <- df_csv %>%
  group_by(mes, sexo_p) %>%
  summarise(
    total_obitos = n(), 
    media = mean(idade_anos, na.rm=TRUE),
    .groups = "drop") %>%
    arrange(desc(total_obitos), media)
print(resultado)
View(resultado)

#3.1
resultado <- df_csv %>%
  mutate(
    DTOBITO_dt = dmy(DTOBITO),
    mes_obito = month(DTOBITO_dt)
  ) %>%
  count(mes_obito, sort=TRUE) %>%
  slice(1)
print(resultado)
View(resultado)

#3.2
masculino <- 0
feminino <- 0

for(sexo in df_csv$sexo_p){
  if(sexo == "Masculino"){
    masculino <- masculino + 1
  } else if(sexo == "Feminino"){
    feminino <- feminino + 1
  }
}

total <- feminino + masculino
diferenca_percentual <- abs(masculino - feminino) / total * 100
print(diferenca_percentual)
print(sprintf("Diferença: %.1f%%", diferenca_percentual))

#3.3
resultado <- df_csv %>%
  count(faixa_etaria, sort=TRUE) %>%
  slice(1)
print(resultado)

write.csv(df_csv, "D:/analise_dados/Analise-de-Dados/analise_dados_R/dados/sim_salvador_2023_final.csv", row.names = FALSE)