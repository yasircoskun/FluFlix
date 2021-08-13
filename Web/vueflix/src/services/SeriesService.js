export async function getSeriesDetail(seriesName) {
    var myHeaders = new Headers();
    myHeaders.append("Content-Type", "application/json");

    var graphql = JSON.stringify({
        query: `
        query{
            series(where:{name:{eq: "` + seriesName + `"}}){
              id,
              name,
              about,
              posterURL,
              seasons{
                id,
                order,
                episodes{
                  id,
                  name,
                  order,
                  resource,
                  streamLink
                }
              }
            }
          }
      `,
        variables: {}
    })
    var requestOptions = {
        method: 'POST',
        headers: myHeaders,
        body: graphql,
        redirect: 'follow'
    };

    const response = await fetch("http://localhost:8080/graphql", requestOptions)

    return await response.json();
}