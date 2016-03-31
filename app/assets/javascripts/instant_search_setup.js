$(document).ready(function() {

var search = instantsearch({
  appId: 'latency',
  apiKey: '6be0576ff61c053d5f9a3225e2a90f76',
  indexName: 'ikea'
});
// alert("asd");
search.addWidget(
  instantsearch.widgets.searchBox({
    container: '#query',
    placeholder: 'Refine your search'
  })
);

// search.on('render', function() {
//   $('.product-picture img').addClass('transparent');
//   $('.product-picture img').one('load', function() {
//       $(this).removeClass('transparent');
//   }).each(function() {
//       if(this.complete) $(this).load();
//   });
// });

// search.addWidget(
//   instantsearch.widgets.stats({
//     container: '#stats'
//   })
// );

var hitTemplate =
    '<div class="result-card">'+
      '<div class="outer-image outer-js">'+
        '<img class="inner-js" src="/assets/578760-cruise-liners.jpg" alt="">'+
      '</div>'+
      '<div class="list-result">'+
        '<h3>Taronga Zoo</h3>'+
        '<p class="desc-result">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Provident ex porro, consequuntur, necessitatibus, molestiae aliquid quas exercitationem error neque deleniti quibusdam laboriosam delectus est molestias praesentium dolores! Voluptate, reiciendis, atque.</p>'+
        '<div class="footer-result">'+
          '<p class="pull-left">For Ages 5-8</p>'+
          '<a class="pull-right" href="#">Book Now</a>'+
        '</div>'+
      '</div>'+
    '</div> ';

  // '<article class="hit">' +
  //     '<div class="product-picture-wrapper">' +
  //       '<div class="product-picture"><img src="{{image}}" /></div>' +
  //     '</div>' +
  //     '<div class="product-desc-wrapper">' +
  //       '<div class="product-name">{{{_highlightResult.name.value}}}</div>' +
  //       '<div class="product-type">{{{_highlightResult.type.value}}}</div>' +
  //       '<div class="product-price">${{price}}</div>' +
  //       '<div class="product-rating">{{#stars}}<span class="ais-star-rating--star{{^.}}__empty{{/.}}"></span>{{/stars}}</div>' +
  //     '</div>' +
  // '</article>';

  var noResultsTemplate =
  '<div class="text-center">No results found matching <strong>{{query}}</strong>.</div>';

  var facetTemplateCheckbox =
          '<div class="checkbox">'+
            '<label>'+
              '<input name="age" type="checkbox"> 5-8'+
            '</label>'+
          '</div>';

  // '<a href="javascript:void(0);" class="facet-item">' +
  //   '<input type="checkbox" class="{{cssClasses.checkbox}}" value="{{name}}" {{#isRefined}}checked{{/isRefined}} />{{name}}' +
  //   '<span class="facet-count">({{count}})</span>' +
  // '</a>';

  search.addWidget(
  instantsearch.widgets.hits({
    container: '#hits',
    hitsPerPage: 8,
    templates: {
      empty: noResultsTemplate,
      item: hitTemplate
    },
  })
);

search.addWidget(
  instantsearch.widgets.refinementList({
    container: '#age',
    attributeName: 'age',
    operator: 'or',
    limit: 10,
    templates: {
      item: facetTemplateCheckbox,
      header: '<h5>Age</h5>'
    }
  })
);
search.addWidget(
  instantsearch.widgets.refinementList({
    container: '#category',
    attributeName: 'category',
    operator: 'or',
    limit: 10,
    templates: {
      item: facetTemplateCheckbox,
      header: '<h5>Category</h5>'
    }
  })
);

search.addWidget(
  instantsearch.widgets.refinementList({
    container: '#materials',
    attributeName: 'materials',
    operator: 'or',
    limit: 10,
    templates: {
      item: facetTemplateCheckbox,
      header: '<div class="facet-title">Materials</div class="facet-title">'
    }
  })
);

search.start();

});
// 'use strict';
/* global instantsearch */


