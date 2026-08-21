return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    event = 'BufReadPost',
    init = function()
      vim.o.foldcolumn = '0'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end

      require('ufo').setup {
        fold_virt_text_handler = handler,
        provider_selector = function()
          return { 'treesitter', 'indent' }
        end,
      }

      -- Highlight groups
      vim.api.nvim_set_hl(0, 'UfoFoldedFg', { fg = vim.api.nvim_get_hl(0, { name = 'Normal' }).fg })
      vim.api.nvim_set_hl(0, 'UfoFoldedBg', { bg = vim.api.nvim_get_hl(0, { name = 'Folded' }).bg })
      vim.api.nvim_set_hl(0, 'UfoPreviewSbar', { link = 'PmenuSbar' })
      vim.api.nvim_set_hl(0, 'UfoPreviewThumb', { link = 'PmenuThumb' })
      vim.api.nvim_set_hl(0, 'UfoPreviewWinBar', { link = 'UfoFoldedBg' })
      vim.api.nvim_set_hl(0, 'UfoPreviewCursorLine', { link = 'Visual' })
      vim.api.nvim_set_hl(0, 'UfoFoldedEllipsis', { link = 'Comment' })
      vim.api.nvim_set_hl(0, 'UfoCursorFoldedLine', { link = 'CursorLine' })

      -- Keymaps
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
      vim.keymap.set('n', 'zf', 'zMzvzz', { desc = 'Focus: Fold everything exc ept current cursor' })
    end,
  },
}
