return {
    "rcarriga/nvim-notify",
    config = function()
        local notify = require("notify")
        notify.setup({
            stages = "fade_in_slide_out",
            timeout = 3000,
            background_colour = "Normal",
            render = "wrapped-default",
            top_down = false,
            max_height = 3,
        })
    end,
}

