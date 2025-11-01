import pandas as pd
import plotly.express as px


dados = pd.read_excel("vendas.xlsx")

dados.head()
dados.tail()
dados.shape
dados.info()
dados.describe()

dados["loja"].value_counts()
dados["loja"].unique()
dados["forma_pagamento"].value_counts()

dados.groupby("loja")["preco"].sum().to_frame()

dados_agrupados = dados.groupby(["estado", "cidade", "loja"])["preco"].sum().to_frame()

dados_agrupados.to_excel("Faturamento.xlsx")

grafico = px.histogram(
    dados, 
    x="loja", 
    y="preco", 
    text_auto=True,
    title="Faturamento",
    color="forma_pagamento"
)

grafico.show()
grafico.write_html("Faturamento.html")

lista_colunas = ["loja", "cidade", "estado", "tamanho", "local_consumo"]

for coluna in lista_colunas: 
    grafico = px.histogram(
        dados, 
        x=coluna, 
        y="preco", 
        text_auto=True,
        title="Faturamento",
        color="forma_pagamento"
    )

    grafico.show()
    grafico.write_html(f"Faturamento-{coluna}.html")
