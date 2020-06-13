# hw3 report

|||
|-:|:-|
|Name|石育瑋|
|ID|A073708|

## How much time did you spend on this project

24 hours.

## Project overview
> 主要按著助教提供引導去完成，雖然spec寫的很詳細，但仍然需要花超級多時間去做．


#### 重點設計想法

> 這次作業整體實作量很大，所以挑幾個在實作中遇到比較新奇的東西來介紹，就不對實作內容一一介紹

1. 傳遞多參數
```cpp
vector<AstNode*> decl_list_program;
vector<AstNode*> function_list_program;
vector<AstNode*> variable_list;
vector<AstNode*> decl_list_function;
vector<AstNode*> expression_list;
vector< vector<AstNode*> > decl_list_compound(10);
vector<AstNode*> statement_list;
vector<AstNode*> arr_ref_list;
vector<char*> identifier_list;
vector<int> col;
```
> 一開始不知道如何都過`$$`一次傳多個參數，雖然沒找到`$$`傳遞多參數的方法，但最後仍用vector去補足這個部分，主要要注意的地方是傳遞完成後，需要將vector清空，不然會導致參數重複使用．

2. Relation bewteen compound statement & statements
```cpp
std::stack<AstNode*> statement_stack;
std::stack<int> statement_cnt_stack;
```
> 因為statement與compound statement兩者可以相互嵌套，所以若只使用單一vector去處理不同compounds裡的statement會發生不同compound之間的內容會亂掉，我嘗試了很多方法，包含使用多個vector去處理不同compound，但要考慮到很多不同狀況，最終因為實作上要顧慮的太多，最後改用stack去實作，先宣告兩個stack，一個stack<int>紀錄compounds有多少個statement，另一個stack<AstNode*>儲存所有的statement，可以想像當在nested的compound與statement之中，當遇到一個compound完成時，就pop出這個compound的statements與他的紀錄值，最後很好解決嵌套的狀況．
  
3. Visitor Pattern
```cpp
virtual void accept(AstDumper &p_visitor) = 0;
```
```cpp
void ProgramNode::accept(AstDumper &p_visitor) { // visitor pattern version
    p_visitor.visit(*this);
}

void ProgramNode::visitChildNodes(AstDumper &p_visitor) { // visitor pattern version
     for (auto &decl : decl_list) {
        decl->accept(p_visitor);
     }

     for (auto &func : function_list) {
        func->accept(p_visitor);
     }

     compound_statement_node->accept(p_visitor);
}
```
> 因為要使用visitor pattern的技巧，所以在基類`AstNode`增加了虛函數access，讓所有繼承的類能透過access去visit到相應print message的function，並完成助教挖空`TODO`的地方．


## What is the hardest you think in this project

> 一開始起頭非常難，毫無頭緒，不知道如何下手，parent與children如何去連接也看了好久，最難的部分應該是compound statement與statement嵌套的問題，在這上面花了很多時間讓coumpound之間不會影響到對方，不過這個問題應該是從我用vector去傳參數引起的，因為多個compound一起使用就會引起混亂．

## Feedback to T.A.s

> `ForNode`註解似乎有小問題，最後謝謝助教提供這麼完善的spec！
