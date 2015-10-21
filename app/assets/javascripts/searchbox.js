$(document).ready(function() {
  var source = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    local: gon.school_names
  });

  source.initialize();

  $('#the-basics .typeahead').typeahead({
    hint: false,
    highlight: true,
    minLength: 1
  },
  {
    name: 'schools',
    source: source.ttAdapter(),
    displayKey: 'value',
    templates: {
       empty: [
        '<div class="empty-message">',
          'Unable to find any schools',
        '</div>'
      ].join('\n'),
      suggestion: Handlebars.compile('<p><a href="{{url}}">{{value}}</a></p>')
    }
  });
});
