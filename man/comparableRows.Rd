% Generated by roxygen2 (4.0.2): do not edit by hand
\name{comparableRows}
\alias{comparableRows}
\title{Find comparable rows in DT for two or more attributes}
\usage{
comparableRows(DT, splitCol, splitVal, compareBy)
}
\arguments{
\item{DT}{data.table}

\item{splitCol}{Dt column name that contains the attributes that should be compared}

\item{splitVal}{two or more values of splitCol that should be compared}

\item{compareBy}{other column names that should be used two decide if a comparable row exists for both splitVals}
}
\value{
indices of DT that show which rows should be retained (TRUE) i.e. rows that have a counterpart in each of the two splitVals
}
\description{
Find comparable rows in DT for two or more attributes
}
\examples{
## Delete rows in DT that have no counterpart for GME/ICON concerning the attributes: "veri_forecast_time","veri_initial_date","varno","statid"

require(ggplot2)
fnames                = system("ls ~/examplesRfdbk/*/synop/verSYNOP.2014*",intern=T)
cond                  = list(varno="varno\%in\%c(3,4)",veri_description="grepl('forecast',veri_description)")
columnnames           = c("obs","veri_data","varno","veri_model","veri_forecast_time","veri_initial_date","statid")
DT                    = fdbk_dt_multi_large(fnames,cond,columnnames,20)
keepind               = comparableRows(DT,splitCol="veri_model",splitVal=unique(DT$veri_model),compareBy=c("veri_forecast_time","veri_initial_date","varno","statid"))
DT                    = DT[keepind]
DT[,.N,by=c("varno","veri_model")]
DT$varno              = varno_to_name(DT$varno)
strat                 = c("varno","veri_forecast_time","veri_model")
scores                = fdbk_dt_verif_continuous(DT,strat)
p =  ggplot(scores,aes(x=veri_forecast_time,y=scores,group=interaction(scorename,varno,veri_model),colour = veri_model, linetype=varno))+
     geom_line(size=.7) + geom_point(size=1.5) + facet_wrap(~scorename, scales = "free")+
     theme_bw()+theme(axis.text.x  = element_text(angle=70,hjust = 1))
p
}
\author{
Felix <felix.fundel@dwd.de>
}

