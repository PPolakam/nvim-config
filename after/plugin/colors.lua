function ColorMyPencils(color)
	color = color or "onedark"
	vim.cmd.colorscheme(color)

	if(color == "onedark") then
	  require("onedarkpro").setup({
  	     styles = {
    		types = "bold",
    		methods = "bold, italic",
    		numbers = "NONE",
    		strings = "NONE",
    		comments = "italic",
    		keywords = "NONE",
    		constants = "NONE",
    		functions = "bold",
    		operators = "NONE",
    		variables = "NONE",
    		parameters = "underline",
    		conditionals = "NONE",
    		virtual_text = "NONE",
  	     }
	  })
        end
	
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.cmd('hi! LineNr guibg=none ctermbg=none')
end

ColorMyPencils()

