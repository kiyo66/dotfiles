return {
    "kkoomen/vim-doge",
    build = ":call doge#install()",
    cmd = { "DogeGenerate", "DogeCreateDocStandard" },
    ft = { "python" },                            -- Python ファイルでのみ読み込む
    config = function()
        vim.g.doge_doc_standard_python = 'google' -- 'google', 'numpy', 'sphinx' から選択可能

        -- オプションの設定
        vim.g.doge_mapping = '<Leader>doc'      -- ドキュメント生成のキーマッピング
        vim.g.doge_comment_jump_modes = { 'n' } -- ジャンプモード (ノーマルモード)
        vim.g.doge_comment_jump_wrap = 1        -- プレースホルダー間のジャンプでラップアラウンドを有効化

        vim.g.doge_python_settings = {
            single_quotes = 0,                                                   -- ダブルクォートを使用
            omit_redundant_param_types = 1,                                      -- 冗長なパラメータ型を省略
            use_classes = 1,                                                     -- クラスを使用する
            return_type_pattern = { "-> ([a-zA-Z0-9_]+)", ": ([a-zA-Z0-9_]+)" }, -- 戻り値型のパターン
            resolve_arg_types = 1,                                               -- 引数の型を解決する
        }
    end,
}
