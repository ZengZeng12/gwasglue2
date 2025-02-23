
#' An S4 class to represent the Summary Set
#'
#' @slot source Eg.IEUopenGWAS (default NA).
#' @slot ss A tibble with the GWAS summary statistics (default NA).
#' @slot metadata  A data.frame with the metadata associated to ss (default NA).
#' @slot variants The RSID/variants associated with ss (default NA).
#' @slot tools The tools that gwasglue2 is going to convert to (default NA).
#' @slot mr_label Exposure/Outcome (default NA).
#' @slot ld_ref The prefix of the plink files (eg. EUR) used to build the LD correlation matrix (default NA).
#' @slot pop The population code in ieugwasr (eg. EUR) used to build the LD correlation matrix (default NA).
setClass("SummarySet",
  slots = c(
    source = "character",
    ss = "tbl_df",
    metadata = "data.frame",
    variants = "character",
    tools = "character",
    mr_label = "character",
    ld_ref = "character",
    pop = "character"
  ),
  prototype = prototype(
    source = NA_character_,
    ss = NA_character_,
    metadata = data.frame(NA),
    variants = NA_character_,
    tool = NA_character_,
    mr_label = NA_character_,
    ld_ref = NA_character_,
    pop = NA_character_
  ),
  contains = class(dplyr::tibble())
)


#' SummarySet function
#'
#' @param ss It uses createSumset function to call ieugwasR and fill @slot ss
#' @param traits ID of GWAS studies to query
#' @param variants Array of SNPs rsids
#' @param tools Array of methods that gwasglue2 ids going to convert the summarySet to (eg. "mr") 
#' @importFrom methods new
#' @return A SummarySet S4 object.
SummarySet <- function(ss, traits, variants, tools) {
  new("SummarySet",
   ss = createSumset(traits = traits, variants = variants),
    tools = tools,
    variants = variants
  )
}

# Get Methods for summary set data (similar in Dataset class)
setGeneric("getSummaryData", function(object) standardGeneric("getSummaryData"))
setMethod("getSummaryData", "SummarySet",
          function(object) {
            return(object@ss)
          })
# Set and get methods for Metadata and Source
# (for now Metadata needs to be in data.frame format: same as ieugwasr::gwasinfo)
setGeneric("setMetadata", function(object, metadata, source, traits) standardGeneric("setMetadata"))
setMethod("setMetadata", "SummarySet",
          function(object, metadata, source,traits) {
            object@source <- source
            if (source == "IEUopenGWAS"){
              object@metadata <- as.data.frame(ieugwasr::gwasinfo(traits))
            }
            else{
              object@metadata <- as.data.frame(metadata)
            }
            return(object)
          })

setGeneric("getMetadata", function(object) standardGeneric("getMetadata"))
setMethod("getMetadata", "SummarySet",
          function(object) {
            return(object@metadata)
          })
setGeneric("getSource", function(object) standardGeneric("getSource"))
setMethod("getSource", "SummarySet",
          function(object) {
            return(object@source)
          })

# Set and get methods for RSID
setGeneric("setRSID",function(object,variants) standardGeneric("setRSID"))
setMethod( "setRSID", "SummarySet",
           function(object,variants) {
             object@variants <- variants
             return(object)
           }
)

setGeneric("getRSID",function(object) standardGeneric("getRSID"))
setMethod("getRSID","SummarySet",
          function(object) {
            return(object@variants)
          }
)

# Set and get methods for tools
setGeneric("setTool",function(object,tools) standardGeneric("setTool"))
setMethod( "setTool", "SummarySet",
           function(object,tools) {
             object@tools <- tools
             message(paste("Gwasglue is going to convert data to ",object@tools))
             return(object)
           }
)

setGeneric("getTool",function(object) standardGeneric("getTool"))
setMethod("getTool","SummarySet",
          function(object) {
            return(object@tools)
          }
)

# Set and get methods for ld_ref
setGeneric("setLDref",function(object,ld_ref) standardGeneric("setLDref"))
setMethod( "setLDref", "SummarySet",
           function(object,ld_ref) {
             object@ld_ref <- ld_ref
             message(paste("Gwasglue is going to harmonise data against ", object@ld_ref, "LD correlation matrix"))
             return(object)
           }
)

setGeneric("getLDref",function(object) standardGeneric("getLDref"))
setMethod("getLDref","SummarySet",
          function(object) {
            return(object@ld_ref)
          }
)

# Set and get methods for mr_label
setGeneric("setMRlabel",function(object,mr_label) standardGeneric("setMRlabel"))
setMethod( "setMRlabel", "SummarySet",
           function(object,mr_label) {
             object@mr_label <- mr_label
             return(object)
           }
)

setGeneric("getMRlabel",function(object) standardGeneric("getMRlabel"))
setMethod("getMRlabel","SummarySet",
          function(object) {
            return(object@mr_label)
          }
)

#
# # Set and get methods for Trait
# setGeneric("setTrait",function(object,traits) standardGeneric("setTrait"))
# setMethod( "setTrait", "SummarySet",
#            function(object,traits) {
#              object@traits <- unique(traits)
#              return(object)
#            }
# )
#
# setGeneric("getTrait",function(object) standardGeneric("getTrait"))
# setMethod("getTrait","SummarySet",
#           function(object) {
#             return(object@traits)
#           }
# )



setGeneric("getZscores",function(object) standardGeneric("getZscores"))
setMethod("getZscores","SummarySet",
          function(object) {
            return(object@zscores)
          }
)

setGeneric("dimData",function(x) standardGeneric("dimData"))
setMethod("dimData", signature=c(x="SummarySet"), function(x) {
    return(dim(x@ss))
})

setMethod(f = "show", signature="SummarySet", definition = function(object) {
  cat("A SummarySet with ", nrow(object@ss), " variants\n")
  print(object@ss)
})
