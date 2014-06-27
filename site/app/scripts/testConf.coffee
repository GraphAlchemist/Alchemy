testConf = 
    dataSource: 'sample_data/ego1.json'
    # graphHeight: () ->
    #     500
    # graphWidth: () ->
    #     800
    nodeOverlap: 10
    nodeRadius: 5
    fixRootNodes: true

alchemy.begin(testConf)
console.log('hello!')