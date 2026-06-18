# Old
nonempty_meshes <-
  stringr::str_glue("https://{Sys.getenv('amgsds_id')}:{Sys.getenv('amgsds_pw')}@amd.rd.naro.go.jp/opendap/AMD/1980/eAPCP/contents.html") |>
  rvest::read_html() |>
  rvest::html_nodes("a") |>
  rvest::html_text() |>
  stringr::str_subset("p....e") |>
  stringr::str_extract("(p....e)") |>
  readr::parse_number()

# Sys4
# nonempty_meshes_fewer <-
#   stringr::str_glue("https://{Sys.getenv('amgsds_id')}:{Sys.getenv('amgsds_pw')}@amd.rd.naro.go.jp/opendap/AMS/MIROC5/historical/2005/eAPCP/contents.html") |>
#   rvest::read_html() |>
#   rvest::html_nodes("a") |>
#   rvest::html_text() |>
#   stringr::str_subset("p....e") |>
#   stringr::str_extract("(p....e)") |>
#   readr::parse_number()

# Sys5
nonempty_meshes_fewer <-
  readr::read_tsv(
  "Name	Last Modified	Size	DAP4 Response Links				DAP2 Response Links			Dataset Viewers
  AMDy2020p3622eTMP_mea.nc	2024-06-18T05:08:42GMT	34200	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3623eTMP_mea.nc	2024-06-18T05:04:10GMT	212597	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3624eTMP_mea.nc	2024-06-18T05:11:16GMT	186922	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3631eTMP_mea.nc	2024-06-18T05:04:19GMT	17473	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3641eTMP_mea.nc	2025-03-22T00:50:37GMT	20425	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3724eTMP_mea.nc	2024-06-18T04:07:28GMT	28659	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3725eTMP_mea.nc	2024-06-18T04:53:52GMT	124551	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3741eTMP_mea.nc	2025-03-22T00:50:37GMT	20425	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3823eTMP_mea.nc	2024-06-18T05:14:11GMT	37195	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3824eTMP_mea.nc	2024-06-18T04:07:36GMT	19616	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3831eTMP_mea.nc	2024-06-18T04:07:40GMT	50882	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3841eTMP_mea.nc	2025-03-22T00:50:37GMT	20425	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3926eTMP_mea.nc	2024-06-18T04:54:13GMT	65703	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3927eTMP_mea.nc	2024-06-18T05:05:00GMT	444185	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3928eTMP_mea.nc	2024-06-18T05:04:52GMT	127334	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p3942eTMP_mea.nc	2025-03-22T00:50:37GMT	20425	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4027eTMP_mea.nc	2024-06-18T05:05:07GMT	108184	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4028eTMP_mea.nc	2024-06-18T04:54:28GMT	176312	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4040eTMP_mea.nc	2025-03-22T00:50:37GMT	20425	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4042eTMP_mea.nc	2025-03-22T00:50:37GMT	20425	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4128eTMP_mea.nc	2024-06-18T04:08:12GMT	184112	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4129eTMP_mea.nc	2024-06-18T05:16:14GMT	40631	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4142eTMP_mea.nc	2025-03-22T00:50:37GMT	20425	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4229eTMP_mea.nc	2024-06-18T05:05:47GMT	494548	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4230eTMP_mea.nc	2024-06-18T05:05:53GMT	31687	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4328eTMP_mea.nc	2024-06-18T04:06:04GMT	26063	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4329eTMP_mea.nc	2024-06-18T04:05:59GMT	42715	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4429eTMP_mea.nc	2024-06-18T04:17:28GMT	124617	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4529eTMP_mea.nc	2024-06-18T04:17:46GMT	20123	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4530eTMP_mea.nc	2024-06-18T04:17:55GMT	411602	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4531eTMP_mea.nc	2024-06-18T04:18:01GMT	55430	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4540eTMP_mea.nc	2025-03-22T00:50:37GMT	20425	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4629eTMP_mea.nc	2024-06-18T04:18:06GMT	67499	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4630eTMP_mea.nc	2024-06-18T04:17:41GMT	532207	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4631eTMP_mea.nc	2024-06-18T05:00:19GMT	148573	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4728eTMP_mea.nc	2024-06-18T04:18:11GMT	22723	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4729eTMP_mea.nc	2024-06-18T04:18:19GMT	139959	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4730eTMP_mea.nc	2024-06-18T05:03:10GMT	1405437	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4731eTMP_mea.nc	2024-06-18T05:11:30GMT	897796	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4740eTMP_mea.nc	2025-03-22T00:50:37GMT	20425	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4828eTMP_mea.nc	2024-06-18T05:00:13GMT	131138	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4829eTMP_mea.nc	2024-06-18T04:55:41GMT	126057	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4830eTMP_mea.nc	2024-06-18T04:06:29GMT	1674707	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4831eTMP_mea.nc	2024-06-18T04:06:48GMT	1432262	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4839eTMP_mea.nc	2024-06-18T04:12:19GMT	27439	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4928eTMP_mea.nc	2024-06-18T04:18:32GMT	259907	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4929eTMP_mea.nc	2024-06-18T04:07:06GMT	1069297	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4930eTMP_mea.nc	2024-06-18T05:15:25GMT	1505291	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4931eTMP_mea.nc	2024-06-18T04:05:21GMT	1773601	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4932eTMP_mea.nc	2024-06-18T04:57:29GMT	1130905	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4933eTMP_mea.nc	2024-06-18T04:05:02GMT	313134	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4934eTMP_mea.nc	2024-06-18T04:15:20GMT	55625	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p4939eTMP_mea.nc	2024-06-18T04:58:09GMT	80957	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5029eTMP_mea.nc	2024-06-18T04:18:42GMT	445890	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5030eTMP_mea.nc	2024-06-18T04:15:38GMT	1375561	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5031eTMP_mea.nc	2024-06-18T05:01:19GMT	916445	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5032eTMP_mea.nc	2024-06-18T04:15:14GMT	1451011	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5033eTMP_mea.nc	2024-06-18T04:15:58GMT	1777670	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5034eTMP_mea.nc	2024-06-18T04:05:45GMT	1142585	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5035eTMP_mea.nc	2024-06-18T04:55:13GMT	1199737	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5036eTMP_mea.nc	2024-06-18T04:04:33GMT	182565	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5039eTMP_mea.nc	2024-06-18T04:59:52GMT	40289	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5129eTMP_mea.nc	2024-06-18T04:18:51GMT	348022	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5130eTMP_mea.nc	2024-06-18T04:16:07GMT	257542	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5131eTMP_mea.nc	2024-06-18T05:09:38GMT	1590395	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5132eTMP_mea.nc	2024-06-18T05:02:53GMT	1758440	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5133eTMP_mea.nc	2024-06-18T05:00:43GMT	1425580	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5134eTMP_mea.nc	2024-06-18T04:16:25GMT	1105681	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5135eTMP_mea.nc	2024-06-18T04:14:07GMT	1641117	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5136eTMP_mea.nc	2024-06-18T05:07:30GMT	1377832	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5137eTMP_mea.nc	2024-06-18T04:13:48GMT	110232	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5138eTMP_mea.nc	2024-06-18T04:14:15GMT	105062	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5139eTMP_mea.nc	2024-06-18T04:57:37GMT	138055	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5229eTMP_mea.nc	2024-06-18T04:18:23GMT	34276	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5231eTMP_mea.nc	2024-06-18T05:03:29GMT	156740	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5232eTMP_mea.nc	2024-06-18T04:16:46GMT	1522549	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5233eTMP_mea.nc	2024-06-18T04:17:06GMT	1798710	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5234eTMP_mea.nc	2024-06-18T05:08:24GMT	1739064	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5235eTMP_mea.nc	2024-06-18T05:02:06GMT	1708503	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5236eTMP_mea.nc	2024-06-18T05:09:19GMT	1421680	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5237eTMP_mea.nc	2024-06-18T04:10:20GMT	1721096	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5238eTMP_mea.nc	2024-06-18T05:11:58GMT	1618087	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5239eTMP_mea.nc	2024-06-18T05:10:24GMT	763318	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5240eTMP_mea.nc	2024-06-18T04:08:39GMT	326471	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5332eTMP_mea.nc	2024-06-18T05:12:18GMT	226375	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5333eTMP_mea.nc	2024-06-18T05:14:49GMT	599725	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5334eTMP_mea.nc	2024-06-18T05:13:33GMT	921081	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5335eTMP_mea.nc	2024-06-18T05:07:11GMT	992658	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5336eTMP_mea.nc	2024-06-18T04:14:35GMT	1862330	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5337eTMP_mea.nc	2024-06-18T04:09:51GMT	2035115	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5338eTMP_mea.nc	2024-06-18T04:58:57GMT	2134995	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5339eTMP_mea.nc	2024-06-18T05:12:36GMT	1423355	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5340eTMP_mea.nc	2024-06-18T04:02:31GMT	842009	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5432eTMP_mea.nc	2024-06-18T04:17:12GMT	47030	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5433eTMP_mea.nc	2024-06-18T04:57:08GMT	223273	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5435eTMP_mea.nc	2024-06-18T04:14:41GMT	23487	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5436eTMP_mea.nc	2024-06-18T04:58:01GMT	1553610	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5437eTMP_mea.nc	2024-06-18T04:09:21GMT	2114067	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5438eTMP_mea.nc	2024-06-18T05:07:53GMT	1962922	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5439eTMP_mea.nc	2024-06-18T05:06:30GMT	1430459	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5440eTMP_mea.nc	2024-06-18T04:59:20GMT	1007515	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5531eTMP_mea.nc	2025-03-22T00:50:37GMT	24889	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5536eTMP_mea.nc	2024-06-18T04:14:55GMT	646035	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5537eTMP_mea.nc	2024-06-18T04:12:09GMT	1046873	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5538eTMP_mea.nc	2024-06-18T04:02:58GMT	1884144	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5539eTMP_mea.nc	2024-06-18T05:10:08GMT	1986514	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5540eTMP_mea.nc	2024-06-18T04:03:18GMT	1552210	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5541eTMP_mea.nc	2024-06-18T05:06:13GMT	53730	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5636eTMP_mea.nc	2024-06-18T04:04:47GMT	118491	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5637eTMP_mea.nc	2024-06-18T05:13:46GMT	205677	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5638eTMP_mea.nc	2024-06-18T04:11:21GMT	682030	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5639eTMP_mea.nc	2024-06-18T04:12:51GMT	1824396	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5640eTMP_mea.nc	2024-06-18T05:12:55GMT	1771901	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5641eTMP_mea.nc	2024-06-18T04:13:32GMT	97429	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5738eTMP_mea.nc	2024-06-18T04:10:30GMT	290992	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5739eTMP_mea.nc	2024-06-18T05:14:05GMT	1305065	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5740eTMP_mea.nc	2024-06-18T04:03:40GMT	1695665	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5741eTMP_mea.nc	2024-06-18T04:11:36GMT	587414	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5839eTMP_mea.nc	2024-06-18T05:03:22GMT	457886	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5840eTMP_mea.nc	2024-06-18T04:11:00GMT	1764154	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5841eTMP_mea.nc	2024-06-18T05:06:54GMT	1437583	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5939eTMP_mea.nc	2024-06-18T05:11:05GMT	166266	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5940eTMP_mea.nc	2024-06-18T03:58:00GMT	1741747	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5941eTMP_mea.nc	2024-06-18T04:08:59GMT	1851437	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p5942eTMP_mea.nc	2024-06-18T05:14:32GMT	104536	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6039eTMP_mea.nc	2024-06-18T04:13:20GMT	203422	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6040eTMP_mea.nc	2024-06-18T03:58:30GMT	1742514	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6041eTMP_mea.nc	2024-06-18T04:56:58GMT	1333093	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6139eTMP_mea.nc	2024-06-18T03:58:39GMT	40913	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6140eTMP_mea.nc	2024-06-18T04:56:39GMT	1111891	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6141eTMP_mea.nc	2024-06-18T05:00:06GMT	636520	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6239eTMP_mea.nc	2024-06-18T03:58:48GMT	62123	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6240eTMP_mea.nc	2024-06-18T05:15:07GMT	1219523	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6241eTMP_mea.nc	2024-06-18T05:12:06GMT	285933	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6243eTMP_mea.nc	2024-06-18T04:09:27GMT	52507	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6339eTMP_mea.nc	2024-06-18T03:59:00GMT	498232	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6340eTMP_mea.nc	2024-06-18T05:01:42GMT	1240783	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6341eTMP_mea.nc	2024-06-18T03:59:13GMT	465344	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6342eTMP_mea.nc	2024-06-18T05:13:17GMT	1225745	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6343eTMP_mea.nc	2024-06-18T05:01:04GMT	868425	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6439eTMP_mea.nc	2024-06-18T05:10:34GMT	35246	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6440eTMP_mea.nc	2024-06-18T03:59:34GMT	1322710	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6441eTMP_mea.nc	2024-06-18T03:59:54GMT	1430518	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6442eTMP_mea.nc	2024-06-18T05:03:49GMT	1830193	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6443eTMP_mea.nc	2024-06-18T05:09:00GMT	1400060	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6444eTMP_mea.nc	2024-06-18T05:02:35GMT	809845	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6445eTMP_mea.nc	2024-06-18T05:04:03GMT	329047	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6540eTMP_mea.nc	2024-06-18T04:57:42GMT	43430	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6541eTMP_mea.nc	2024-06-18T04:56:07GMT	1163936	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6542eTMP_mea.nc	2024-06-18T04:00:16GMT	1795928	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6543eTMP_mea.nc	2024-06-18T05:10:53GMT	1766720	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6544eTMP_mea.nc	2024-06-18T04:00:38GMT	1487850	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6545eTMP_mea.nc	2024-06-18T05:08:03GMT	444922	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6641eTMP_mea.nc	2024-06-18T04:13:08GMT	698521	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6642eTMP_mea.nc	2024-06-18T04:00:59GMT	1683819	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6643eTMP_mea.nc	2024-06-18T04:55:29GMT	922031	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6644eTMP_mea.nc	2024-06-18T04:12:30GMT	167939	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6645eTMP_mea.nc	2024-06-18T04:11:46GMT	287416	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6741eTMP_mea.nc	2024-06-18T04:59:35GMT	747061	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6742eTMP_mea.nc	2024-06-18T04:01:33GMT	1065772	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6840eTMP_mea.nc	2024-06-18T04:01:46GMT	44908	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6841eTMP_mea.nc	2024-06-18T05:13:40GMT	222399	dmr	dap	html	rdf	dds	das	info	viewers
  AMDy2020p6842eTMP_mea.nc	2024-06-18T04:01:55GMT	72900	dmr	dap	html	rdf	dds	das	info	viewers") |>
  dplyr::pull(Name) |>
  stringr::str_sub(10, 13) |>
  as.numeric()

usethis::use_data(nonempty_meshes, overwrite = TRUE)
usethis::use_data(nonempty_meshes_fewer, overwrite = TRUE)
