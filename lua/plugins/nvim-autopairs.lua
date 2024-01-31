return {
    "windwp/nvim-autopairs",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
        local ap = require("nvim-autopairs")

        -- Configure default options
        ap.setup({
            enable_check_bracket_line = true,
        })

        -- Automatically add `(` after selecting a function or method
        -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        -- local cmp = require("cmp")
        -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

        local rule = require("nvim-autopairs.rule")

        -- Rule for adding a leading and trailing space inside bracket pairs
        local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }

        ap.add_rules({
            rule(" ", " "):with_pair(function(opts)
                local pair = opts.line:sub(opts.col - 1, opts.col)
                return vim.tbl_contains({
                    brackets[1][1] .. brackets[1][2],
                    brackets[2][1] .. brackets[2][2],
                    brackets[3][1] .. brackets[3][2],
                }, pair)
            end),
        })

        for _, bracket in pairs(brackets) do
            ap.add_rules({
                rule(bracket[1] .. " ", " " .. bracket[2])
                    :with_pair(function()
                        return false
                    end)
                    :with_move(function(opts)
                        return opts.prev_char:match(".%" .. bracket[2]) ~= nil
                    end)
                    :use_key(bracket[2]),
            })
        end

        -- Rule for disabling autopairs for single quotes in rust files (lifetimes and byte strings)
        -- ap.get_rule("'")[1].not_filetypes = { "rust" }
    end,
}
