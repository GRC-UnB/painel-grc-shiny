#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)
library(data.table)
library(crosstalk)

# Carregando os dados
dados = fread("GRC_UNB.csv", encoding = "UTF-8")

data = dados$data


shinyServer(function(input, output) {
    # Função reativa que altera a filtragem dos dados para tabela
    dados_tabela <- reactive({
        tipo_politica = input$tipo_politica[1]
        data1 = input$periodo[1]
        data2 = input$periodo[2]
        
        cat("Dados da tabela ", tipo_politica, "\n")
        orgaos = dados
        
        orgaos$politica = orgaos[[tipo_politica]]
        
        orgaos = orgaos %>%
            filter(!is.na(politica),
                   data >= data1,
                   data <= data2) %>%
            group_by(politica, data) %>%
            summarise(orgaos = paste0(nome_tratado)) %>%
            ungroup()
        
        return(orgaos)
    })
    # Função reativa que altera a filtragem dos dados para o gráfico
    dados_grafico <- reactive({
        tipo_politica = input$tipo_politica[1]
        data1 = input$periodo[1]
        data2 = input$periodo[2]
        
        cat("Dados dos gráficos ", tipo_politica, "\n")
        
        grc = dados
        
        grc$politica = grc[[tipo_politica]]
        
        grc = grc %>%
            filter(!is.na(politica),
                   data >= data1,
                   data <= data2) %>%
            group_by(politica, data) %>%
            summarise(quantitativo = n())
        
        return(grc)
    })
    
    # Exibição dos gráficos
    output$grafico <- renderPlotly({
        dados_grafico() %>%
            mutate(data = as.Date(data)) %>%
            plot_ly(
                x = ~ data,
                y = ~ quantitativo,
                stroke =  ~ politica,
                color = ~ politica,
                type = "bar"
            ) %>%
            # O título também pode ser passado por meio de uma string, caso seja desejado
            layout(
                title = paste0("Quantidade de órgãos adotantes e não adotantes"),
                yaxis = list(title = "Quantidade"),
                xaxis = list(tickformat =  '%m/%Y'),
                sliders = "steps",
                barmode = 'stack',
                bargap = 0,
                font = list(family = 'sans-serif'),
                hoverlabel = list(x = 2020,
                                  font = list(size = 15)),
                # O hover considera toda área na horizontal e mostra todos os gráficos no mesmo valor de x
                hovermode = "x unified"
            )
    })
    
    
    # Exibição da tabela com o data table
    output$tabela <- renderDataTable({
        dados_tabela()
    },
    options = list(pageLength = 15))
})
