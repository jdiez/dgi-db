$ ->
  poptable = (t) ->
    rows = $(t).find("tr:gt(0)")
    last_row = null 
    rows.each(
      (row_n) ->
        row = this
        if (last_row != null)
          $(this).children("td").each(
            (col_n) -> 
              this_cell = row.cells[col_n].innerHTML
              prev_cell = last_row.cells[col_n].innerHTML
              if (this_cell != prev_cell)
                this.style.opacity = 1
              else
                this.style.opacity = .5
          )
        last_row = row
    )

  $(".table[id!='table-by-source'][id!='refine-results-table']").dataTable
    sPaginationType: "bootstrap"
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    sWrapper: "dataTables_wrapper form-inline"
    oLanguage:
      sSearch: 'Filter results:'
      sLengthMenu: "_MENU_ records per page"
    fnDrawCallback: (o) -> poptable(o.nTable)

  lastCol = $('#table-by-source th').size()-1
  $("#table-by-source").dataTable
    aaSorting: [[lastCol, "desc"], [0, "asc"]]
    sPaginationType: "bootstrap"
    iDisplayLength: "50"
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    sWrapper: "dataTables_wrapper form-inline"
    oLanguage:
      sSearch: 'Filter results:'
      sLengthMenu: "_MENU_ records per page"
      fnDrawCallback: (e) -> alert(e)

  $("#interaction_tab").tab("show")

  #$("#search-again").on 'click', ->
    #gene_symbols = []
    #$("button.active").each -> gene_symbols.push $(this).val()
    #gene_symbols = [gene_symbols.join("\n"), $("#definite_results").val(), $("#no_results").val()].join("\n")
    #$.post(


