#' Title
#'
#' @param object Psychometric object
#' @param scale, scale to find best items for
#' @param nItems, number of items in new scale
#'
#' @return best item object
#' @export
#'
#' @examples
#' object <- GetPsychometric(persData, c("Achievement", "Dutifulness", "Orderly"),
#'  responseScale = list(c(0,4)), itemLength = 4)
#' res <- bestItems(object, "Achievement", 3)
#'
bestItems <- function(object,  scale, nItems) {
  UseMethod("bestItems", object)
}

#' @export
bestItems.Psychometric <- function(object, scale, nItems)
{


  res <- psych::bestScales(cbind(object$ScaleItemFrames[[scale]], object$ScaleFrame[scale]),
                    criteria = scale, n.item = nItems-1, dictionary = object$ItemDictionary)
  print(res)
  return(res)
}

#' BestScales
#'
#' @param object Psychometric object
#' @param nItems Number of items in new scales
#' @param deleteItems F = allitems are left in the object. T: items not selected are deleted
#'
#' @return Psychometric object with scale means using the best nItems items
#' @export
#'
#' @examples
#' object <- GetPsychometric(persData, c("Achievement", "Dutifulness", "Orderly"),
#'  responseScale = list(c(0,4)), itemLength = 4)
#' res <- bestScales(object,  5)

bestScales <- function(object, nItems, deleteItems = F) {
  UseMethod("bestScales",object)
}


#' @export
bestScales.Psychometric <- function(object, nItems, deleteItems = F)
{
  for (scale in object$ScaleNames)
  {
    res <-bestItems(object, scale, nItems)
    items <- object$ScaleItemFrames[[scale]]
    items <- items[res$best.keys[[1]]]
    object$ScaleFrame[scale] <- rowMeans(as.data.frame(items), na.rm = F)
    if (deleteItems)
    {
      object$ScaleItemFrames[[scale]] <- items
    }
  }
   return(object)
}
