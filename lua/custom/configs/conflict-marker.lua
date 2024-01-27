local M = {
  function ()
    vim.api.nvim_command('highlight ConflictMarkerBegin guibg=#2f7366')
    vim.api.nvim_command('highlight ConflictMarkerOurs guibg=#2e5049')
    vim.api.nvim_command('highlight ConflictMarkerTheirs guibg=#344f69')
    vim.api.nvim_command('highlight ConflictMarkerEnd guibg=#2f628e')
    vim.api.nvim_command('highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81')
  end
}

return M
