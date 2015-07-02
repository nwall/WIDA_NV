############################################################################
###
### Script for calculating SGPs for 2015 for WIDA/ACCESS/NV
###
############################################################################

### Load SGP package

require(SGP)


### Load Data

load("Data/WIDA_NV_Data_LONG.Rdata")


### Run analyses

WIDA_NV_SGP <- abcSGP(
		WIDA_NV_Data_LONG,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP", "visualizeSGP"),
		sgp.percentiles=TRUE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=TRUE,
		sgp.projections.baseline=TRUE,
		sgp.projections.lagged.baseline=TRUE,
		sgp.target.scale.scores=TRUE,
		plot.types=c("studentGrowthPlot", "growthAchievementPlot"),
		parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4, GA_PLOTS=1, SG_PLOTS=1)))


### Save results

save(WIDA_NV_SGP, file="Data/WIDA_NV_SGP.Rdata")
