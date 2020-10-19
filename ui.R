#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)
library(data.table)
library(shinydashboard)
rm(list = ls())

dados = fread("GRC_UNB.csv", encoding = "UTF-8")

data = dados$data

citacao = "<h3>Como citar?</h3> <br> <p>Gustavo ALVES, Carlos Denner dos SANTOS; 2020.
<b>Painel Unificado da Adoção de Práticas Gerenciais pelo Órgãos Públicos Federais Brasileiros: uma base de dados integrativa do SIAPE, SIORG, SIOP, e o levantamento de governança do TCU</b>.
Disponível em <a href='https://grc-unb.github.io/post.html'>https://grc-unb.github.io/post.html</a>
</p>"
shinyUI(dashboardPage(
    skin = "black",
    # Application title
    dashboardHeader(title = "Sociedados"),
    
    # Sidebar with a slider input for number of bins
    dashboardSidebar(
        # sidebarPanel(
        sliderInput(
            inputId = "periodo",
            label = "Período",
            min = as.Date(min(data)),
            max =  as.Date(max(data)),
            # step = "month",
            value = c(as.Date(min(data)), as.Date(max(data))),
            # language = "pt-br",
            timeFormat = "%b-%Y"
        ),
        radioButtons(
            "tipo_politica",
            "Escolha o tipo de política",
            # choices = c("GRC","POSIC","Integridade"),
            selected = "politica_grc",
            choiceNames = c("GRC", "POSIC", "Integridade"),
            choiceValues = c("politica_grc", "plano_int", "politica_posic")
        )
    ),
    
    # Área de exibição dos dados
    dashboardBody(
        tags$head(
            # Carrega o CSS e a fonte
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
            tags$link(rel = "stylesheet", type = "text/css", href = "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"),
            tags$link(rel = "stylesheet", type = "text/css", href =
                          "https://fonts.googleapis.com/css?family=Righteous%7CMerriweather:300,300i,400,400i,700,700i")
        ),
        # Dentro de um layout vertical, insere os gráficos e tabelas
        verticalLayout(plotlyOutput("grafico"), #
                       HTML(citacao),
                       dataTableOutput("tabela"))
    )
))
