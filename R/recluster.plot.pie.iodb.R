recluster.plot.pie.iodb <-
  function(long,
           lat,
           mat = NULL,
           distances = NULL,
           loc = NULL,
           areas = NULL,
           square = 2.5,
           map = NULL,
           sea = NULL,
           countrycol = NULL,
           layer = NULL,
           layerpal = NULL,
           add = F,
           minsize = NULL,
           proportional = T,
           xlim = NULL,
           ylim = NULL,
           main = NULL,
           xlab = NULL,
           ylab = NULL,
           ...) {

   outline <- maps::map(map, plot = FALSE)
    xrange <- range(outline$x, na.rm = TRUE)
    yrange <- range(outline$y, na.rm = TRUE)
    xbox <- xrange + c(-2, 2)
    ybox <- yrange + c(-2, 2)
    if (is.null(mat) & is.null(distances)) {
        stop("A distance matrix or a colour matrix from recluster.col must be provided")
    }
    if (is.null(loc)) {
        if (is.null(areas)) {
            areas <- rep(1, length(lat))
        }
        latsq <- floor(lat/square) * square
        longsq <- floor(long/square) * square
        newcoord <- cbind(aggregate(long ~ longsq + latsq + areas, 
            FUN = "mean"), aggregate(lat ~ longsq + latsq + areas, 
            FUN = "mean")[, 4])
        for (k in 1:nrow(newcoord)) {
            quali1 <- c(1:length(lat))[which(latsq == newcoord[k, 
                2])]
            quali2 <- quali1[which(longsq[quali1] == newcoord[k, 
                1])]
            quali3 <- quali2[which(areas[quali2] == newcoord[k, 
                3])]
            if (length(quali3) > 0) {
                loc[quali3] <- k
            }
        }
    }
    if (is.null(xlim)) {
        xlim <- range(long)
    }
    if (is.null(ylim)) {
        ylim <- range(lat)
    }
    xylim <- cbind(xlim, ylim)
    if (is.null(countrycol)) {
          countrycol <- "gray"
     }
           
    plot(cbind(xlim, ylim), type = "n", xaxt = "n", yaxt = "n", 
        xlab = "", ylab = "", xaxs = "i", yaxs = "i")
    if (!is.null(map)) {
        sp::plot(map, asp = 2, add = T, xlab = xlab, ylab = ylab, 
            col = countrycol, fill = T, lwd = 0.7, border = "black", 
            bg = "azure2", cex.axis = 0.7, main = main)
    }
    polypath(c(outline$x, NA, c(xbox, rev(xbox))), c(outline$y, 
        NA, rep(ybox, each = 2)), col = "azure2", rule = "evenodd")
    if (is.null(minsize)) {
        minsize <- square/6
    }
    for (i in 1:max(loc)) {
        specim <- which(loc == i)
        if (length(specim) == 1) {
            specimens <- c(long[specim], lat[specim], mat[specim, 
                ])
            color3d <- rgb(specimens[5], specimens[6], specimens[7], 
                maxColorValue = 255)
            floating.pie(specimens[1], specimens[2], 1, radius = minsize, 
                border = NA, col = color3d)
            draw.circle(specimens[1], specimens[2], radius = minsize)
        }
        if (length(specim) > 1) {
            specimens <- cbind(long[specim], lat[specim], mat[specim, 
                ])
            if (length(specim) > 3) {
                dista <- dist(mat[specim, 3:5])
                if (sum(dista) > 0) {
                  mds <- cbind(c(1:length(specim)), cmdscale(dist(mat[specim, 
                    3:5]), k = 1))
                  specimens <- specimens[order(mds[, 2]), ]
                }
            }
            if (proportional) {
                rad <- minsize * (length(specim))^0.25
            }
            else {
                rad <- minsize
            }
            color3d <- rgb(specimens[, 5], specimens[, 6], specimens[, 
                7], maxColorValue = 255)
            floating.pie(mean(specimens[, 1]), mean(specimens[, 
                2]), rep(1, length(specim)), border = alpha("#000000", 
                0.5), radius = rad, col = color3d)
            draw.circle(mean(specimens[, 1]), mean(specimens[, 
                2]), radius = rad)
        }
    }
  }
