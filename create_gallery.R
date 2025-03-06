devtools::load_all("../tmap.cartogram/")
devtools::load_all("../tmap")

## choropleth World
data(World)
(tm0 = tm_shape(World, crs = "+proj=eck4") +
	tm_polygons(
		fill = "gender",
		fill.scale = tm_scale_intervals(n=5, values = "-tableau.classic_orange_blue"),
		fill.legend = tm_legend(
			"Gender Inequality Index (GII)", 
			position = tm_pos_on_top(pos.h = "left", pos.v = "bottom"), 
			bg.color = "white")) +
	tm_options(earth_boundary = TRUE, frame = FALSE, earth_boundary.lwd = 2, outer.margins = 0.01, bg.color = "gray98", space.color = "white") +
	tm_credits("UNDP: Human Development Report (2024)", position = tm_pos_on_top(pos.h = "left", pos.v = "bottom"), size = .6))

tmap_save(tm0, filename = "gallery/choro_wld.png", width = 7, height = 3.7, scale = .5)

Africa = World[World$continent == "Africa", ]
stadia = "19835319-4cc3-474b-946e-395160eab966"
data(World)
(tm0b = tm_shape(World) + 
		tm_polygons("grey95") +
		tm_shape(Africa, is.main = TRUE, ext = 1.05) +
		tm_polygons(
			fill = c("inequality", "gender", "press"),
			fill.legend = tm_legend_hide(),
			fill.scale = list(tm_scale_categorical(values = "bu_br_div", n.max = 177, values.range = c(.2, .8)),
							  tm_scale_categorical(values = "bu_br_div", n.max = 177, values.range = c(.2, .8)),
							  tm_scale_categorical(values = "-bu_br_div", n.max = 177, values.range = c(.2, .8)))) +
	tm_facets_hstack() +
		tm_layout(panel.labels = c("Income inequality", "Gender Inequality", "Press Freedom")) +
	tm_add_legend(fill = c4a("bu_br_div", n = 7, range = c(0.2, 0.8)), type = "polygons", labels = c("Best", "", "",  "Middle", "", "", "Worst"), orientation = "landscape", position = tm_pos_out("center", "bottom"), lwd = 0.5, width = 100, frame = FALSE) +
		tm_title("Ranking African countries"))

tmap_save(tm0b, filename = "gallery/choro_africa.png", width = 7, height = 3.5, scale = .5)



## choropleth NLD
bb = bb(NLD_prov[7,], ext = 1.1)
bb = bb(NLD_prov[9,], width = 2, height = 1.3, relative = TRUE)
bb = bb(NLD_muni[NLD_muni$name == "Valkenburg aan de Geul", ], ext = 4) 

bb = sf::st_bbox(c(xmin = 50000, xmax = 150000, ymin = 410000, ymax = 500000), crs = 28992)


(tm2a = tm_shape(NLD_dist, bbox = bb) +
	tm_polygons(
		fill = c("edu_appl_sci", "income_high", "dwelling_value"),
		fill.scale = list(tm_scale_continuous(values = "plasma", n = 7, label.format = list(suffix = "%")),
						  tm_scale_continuous(values = "viridis", n = 7, label.format = list(suffix = "%")),
						  tm_scale_continuous_pseudo_log(values = "cividis", n = 7, label.format = list(suffix = "k"))),
		fill.legend = tm_legend("", 
								frame = FALSE, 
								na.show = FALSE, 
								orientation = "landscape", 
								item.r = 0),
		col = "black",
		lwd = 0.3,
		fill.free = TRUE
	) +
	tm_shape(NLD_muni) +
	tm_borders(lwd = 1) +
	tm_shape(NLD_prov) +
	tm_borders(lwd = 3) +
	tm_facets_hstack() +
	tm_basemap(.tmap_providers$CartoDB.PositronNoLabels) +
	tm_options(outer.margins = 0.01, panel.label.bg.color = "grey95", panel.labels = c("University degree", "High income class", "Average dwelling value")))


tmap_save(tm2a, filename = "gallery/facets_choro.png", width = 7, height = 2.5, scale = .5)

(tm2b = tm_shape(NLD_dist, bbox = bb) +
		tm_cartogram_ncont(
			size = "population",
			fill = c("edu_appl_sci", "income_high", "dwelling_value"),
			fill.scale = list(tm_scale_continuous(values = "plasma", n = 7, label.format = list(suffix = "%")),
							  tm_scale_continuous(values = "viridis", n = 7, label.format = list(suffix = "%")),
							  tm_scale_continuous_pseudo_log(values = "cividis", n = 7, label.format = list(suffix = "k"))),
			fill.legend = tm_legend("", frame = FALSE, na.show = FALSE, orientation = "landscape", item.r = 0),
			col = "black",
			lwd = 0.3,
			fill.free = TRUE
		) +
		tm_shape(NLD_muni) +
		tm_borders(lwd = 1) +
		tm_shape(NLD_prov) +
		tm_borders(lwd = 3) +
		tm_facets_hstack() +
		tm_basemap(.tmap_providers$CartoDB.PositronNoLabels) +
		tm_options(outer.margins = 0.01, panel.labels = c("University degree", "High income class", "Average dwelling value")))


tmap_save(tm2b, filename = "gallery/facets_ncont.png", width = 7, height = 2.5, scale = .5)

# 
# 	tm_title("Proportion of Population Aged 15–75 with a University or Applied Sciences Degree by District (as of October 1, 2022)", 
# 			 width = 15, 
# 			 position = tm_pos_in("left", "top"), 
# 			 z = 0) +
# 	tm_compass(position = tm_pos_in("left", "bottom")) +
# 	tm_scalebar(position = tm_pos_in("left", "bottom")) +
# 	tm_credits("© Data: Statistics Netherlands, Software: R-tmap",
# 			   position = tm_pos_in("left", "bottom"))


## bubble map NLD

tm_shape(NLD_dist) +
	tm_symbols(
		size = "population",
		fill = "income_high",
		col = "black",
		size.scale = tm_scale_continuous(values.scale = 2),
		fill.scale = tm_scale_intervals(n = 5, values = "-tol.rainbow_wh_br"))



## cartogram dorling

World = World[World$iso_a3 != "ATA", ]

World$name[World$iso_a3 == "USA"] = "USA"
World$name[World$iso_a3 == "GBR"] = "UK"
World$name[World$iso_a3 == "COD"] = "DRC"
tm1 = tm_shape(World, crs = "+proj=robin") +
	tm_cartogram_dorling(size = "pop_est", 
						 fill = "press",
						 fill.scale = tm_scale_continuous(values = "cols4all.pu_gn_div", midpoint = 50),
						 fill.legend = tm_legend("", height = 30)) +
	tm_text("name", size = "pop_est", 
			size.legend = tm_legend_hide(), 
			size.scale = tm_scale_continuous(values.scale = 1.5, limits = c(60e6, 1.5e9),
											 values.range = c(0, 1), values = tm_seq(0, 1, power = .15), outliers.trunc = F)) +
	tm_title("World Press Freedom Index") +
	tm_credits("Reporters without Borders - rsf.org", position = tm_pos_in("RIGHT", "BOTTOM")) +
	tm_layout(outer.margins = 0.01)

tmap_save(tm1, filename = "gallery/dorling.png", width = 7, height = 3.7, scale = .5)

## bubble map


(tm3a = tm_shape(NLD_muni) +
		tm_symbols(
			size = "population",
			size.legend = tm_legend("Population"),
			fill = "employment_rate",
			fill.legend = tm_legend("Employment Rate"),
			col = "black",
			size.scale = tm_scale_continuous(values.scale = 3),
			fill.scale = tm_scale_intervals(n = 5, values = "-tol.rainbow_wh_br")) +
		tm_credits("Statistics Netherlands (2024)", position = tm_pos_in("LEFT", "BOTTOM")) +
		tm_title("Employment rate per municipality (2022)"))


tmap_save(tm3a, filename = "gallery/bubble_nld.png", width = 5, height = 5, scale = .5)

