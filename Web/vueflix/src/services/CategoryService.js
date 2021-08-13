export async function getCategorySlider() {
    var myHeaders = new Headers();
    myHeaders.append("Content-Type", "application/json");

    var graphql = JSON.stringify({
        query: `
          query{
            category(){
                name
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