# Rubyのガベージコレクタは「マークアンドスウィープ」というプロセスを使っている
# ①オブジェクトグラフを辿って、コードから到達可能なオブジェクトにマークをつける（マークフェーズ）
# ②マークがつけられなかったオブジェクトを解放する（スウィープフェーズ）

# Ruby2.1では「世代別ガベージコレクタ」が導入された
# 1回のマークフェーズを生き延びたオブジェクトは「古いオブジェクト」
# 2回目以降で初めて出てきたオブジェクトは「新しいオブジェクト」
# ①マークフェーズが「メジャー」と「マイナー」の2種類に分かれる。メジャーは全てのオブジェクトにマークをつける、マイナーは新しいオブジェクトのみを対象とする
# ②スウィープフェーズも「即時モード」「遅延モード」の2つがある。「即時モード」はマークのない全てのオブジェクトを解放する

# Rubyのメモリプール：「ヒープ」←「ページ」←「スロット」　スロットがオブジェクト1つ分

GC.stat
{
  :count=>10, # ガベージコレクタが合計10回実行された。
  :heap_allocated_pages=>132, 
  :heap_sorted_length=>133, # ヒープに現在あるページ数
  :heap_allocatable_pages=>0, 
  :heap_available_slots=>53803, 
  :heap_live_slots=>21627, # 今生きているオブジェクトの数
  :heap_free_slots=>32176, # 使用済みオブジェクトの数
  :heap_final_slots=>0, 
  :heap_marked_slots=>21225, 
  :heap_swept_slots=>32578, 
  :heap_eden_pages=>132, 
  :heap_tomb_pages=>0, 
  :total_allocated_pages=>132, 
  :total_freed_pages=>0, 
  :total_allocated_objects=>153003, # Rubyプログラムが起動してから作られたオブジェクトが153003個
  :total_freed_objects=>131376,     # Rubyプログラムが起動してから解放されたオブジェクトが131376個　↑との差が今生きているオブジェクトの数
  :malloc_increase_bytes=>10480, 
  :malloc_increase_bytes_limit=>16777216, 
  :minor_gc_count=>6, :major_gc_count=>4, # ガベージコレクタがマイナーモードで6回、メジャーモードで4回実行された
  :remembered_wb_unprotected_objects=>257, 
  :remembered_wb_unprotected_objects_limit=>514, 
  :old_objects=>20815, :old_objects_limit=>41630, # 古いオブジェクトでマイナーマークフェーズでは処理されないものが20815個。若いオブジェクト＝heap_live_slots - old_objects
  :oldmalloc_increase_bytes=>10864, 
  :oldmalloc_increase_bytes_limit=>16777216
}

=begin
＜この項目で気づいたこと・学んだこと＞
・ヒープのなかのページに、スロットがあり、スロットに1つのオブジェクトが格納される。
・マークしてスウィープする
・古いオブジェクトはマイナーマークフェーズではスルーされる。
=end
