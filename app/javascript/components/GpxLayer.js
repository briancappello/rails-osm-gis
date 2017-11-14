import React from 'react'
import PropTypes from 'prop-types'
import { GPX } from 'leaflet-gpx'

export default class GpxLayer extends React.Component {
  static contextTypes = {
    map: PropTypes.object,
  }

  componentWillMount() {
    const { map } = this.context
    const { url } = this.props

    const gpx = new GPX(`http://localhost:3000${url}`, {
      async: true,
      parseElements: ['track'],
      marker_options: {
        startIconUrl: '/assets/pin-icon-start.png',
        endIconUrl: '/assets/pin-icon-end.png',
        shadowUrl: '/assets/pin-shadow.png'
      },
      wptIconUrls: {
        '': '/assets/pin-icon-wpt.png'
      }
    }).on('loaded', (e) => {
      map.fitBounds(e.target.getBounds(), { padding: [30, 30] })
    }).addTo(map)
  }

  render() {
    return null
  }
}
