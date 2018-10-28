/* rope */
	rp.copy(l,r-l+1,c);rp.insert(l,d,strlen(d));
	
/* pbds */
	tree<int,null_type,less<int>,rb_tree_tag,tree_order_statistics_node_update> tr;
	
/* stack size */
	char *p;
	p=(char*)malloc(256<<20)+(256<<20);
	#if (defined __unix) or (defined _WIN64)
		__asm__("movq %0,%%rsp\n" :: "r"(p));
	#else 
		__asm__("movl %0,%%esp\n" :: "r"(p));
	#endif 
	
/*random*/
inline int random(int x){return (rand()<<15|rand())%x;}
