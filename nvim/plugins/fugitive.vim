"【Ctrl + g + Ctrl + g】 git status
nnoremap <silent><C-g><C-g> :tab sp<CR>:Gstatus<CR>

"【Ctrl + g + p】 git push
nnoremap <silent><C-g>p :!git push<CR>

"【Ctrl + g + l】 git pull
nnoremap <silent><C-g>l :Git pull<CR>

"【Ctrl + g + f】 git fetch
nnoremap <silent><C-g>f :Git fetch<CR>

"【Ctrl + g + h】 history of opening file
nnoremap <silent><C-g>h :tab sp<CR>:0Glog<CR>

" fugitive default mappings
" https://woodyzootopia.github.io/2019/04/vim%E3%81%A7git%E3%82%82%E7%88%86%E9%80%9F%E7%B7%A8%E9%9B%86/

" s   	    ステージ(add)する
" u	        ステージしたものを取り除く(undo)
" =	        diffをその場に開く・閉じる
" dv	    変化の見やすい、いい感じのdiffを出す（すごく見やすいのでお試しあれ）
" <Enter>	編集する
" X	        変更を取り消す
 
" cc	    コミットする
" ca	    直前のコミットを変更する形でコミットする(git commit --amend)
" ce	    直前のコミットを変更する形でコミットするただし、コミットメッセージを変更しない(git commit --amend --no-edit)
" cw	    直前のコミットのコミットメッセージのみを変更する
" cvc    	verboseモードでコミットする(git commit -v)
" cf	    fixup!でコミットする(git commit --fixup=)これを実行して直後に<Tab><Enter>をおすとHEADにfixupする