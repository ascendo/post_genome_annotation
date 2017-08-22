library(pheatmap)
library(RColorBrewer)
library(dendsort)

up<-read.table(file="differencially_expressed_genes_expression_downpart",row.names=1,header=F,fill=T,quote="",sep = "\t")
up<-up[,49:96]
aa<-read.table("sample_name")
colnames(up)<-aa[,1]
col1=colorRampPalette(c("green","green","red","red"))(100)

set.seed(4)
up_p<-pheatmap(up[sort(c(seq(4,48,6),seq(4,48,6)+1,seq(4,48,6)+2))],border=F,col=col1,cluster_rows=T,cluster_cols=T,scale="row",legend=T,show_colnames=T,show_rownames=F,kmeans_k=6)
pheatmap(up[names(up_p$kmeans$cluster[order(up_p$kmeans$cluster)]),sort(c(seq(4,48,6),seq(4,48,6)+1,seq(4,48,6)+2))],cluster_rows=F,scale="row",cluster_cols=T,col=col1,show_rownames=F,filename="DEG_expression_downpart_scale.pdf")
write.table(names(up_p$kmeans$cluster[up_p$kmeans$cluster==1]),file="downpart_DEG_cluster1_gene_list",,quote=F,col.names=F,row.names=F)
write.table(names(up_p$kmeans$cluster[up_p$kmeans$cluster==2]),file="downpart_DEG_cluster2_gene_list",,quote=F,col.names=F,row.names=F)
write.table(names(up_p$kmeans$cluster[up_p$kmeans$cluster==3]),file="downpart_DEG_cluster3_gene_list",,quote=F,col.names=F,row.names=F)
write.table(names(up_p$kmeans$cluster[up_p$kmeans$cluster==4]),file="downpart_DEG_cluster4_gene_list",,quote=F,col.names=F,row.names=F)
write.table(names(up_p$kmeans$cluster[up_p$kmeans$cluster==5]),file="downpart_DEG_cluster5_gene_list",,quote=F,col.names=F,row.names=F)
write.table(names(up_p$kmeans$cluster[up_p$kmeans$cluster==6]),file="downpart_DEG_cluster6_gene_list",,quote=F,col.names=F,row.names=F)


