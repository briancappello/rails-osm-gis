function v1(uri) {
  return `/api/v1${uri}`
}

function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response
  }

  const e = new Error(response.statusText)
  e.response = response
  throw e
}

function parseJSON(response) {
  if (response.status == 204 || response.status == 205) {
    return null
  }
  return response.json()
}

function dateConverter(fields) {
  return function(obj) {
    return Object.assign({}, obj, fields.reduce((acc, field) => {
      acc[field] = new Date(obj[field])
      return acc
    }, {}))
  }
}

function get(url) {
  return fetch(url)
    .then(checkStatus)
    .then(parseJSON)
}

export default class Api {
  static getRide(id) {
    return new Promise((resolve, reject) => {
      get(v1(`/rides/${id}`)).then(
        (ride) => resolve(dateConverter(['start_time', 'end_time', 'created_at', 'updated_at'])(ride)),
        (error) => reject(error)
      )
    })
  }
}
