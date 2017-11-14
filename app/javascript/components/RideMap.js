import React from 'react'

import GpxLayer from './GpxLayer'

import { Map, TileLayer } from 'react-leaflet'

import 'leaflet/dist/leaflet.css'

const tileServer = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
// const tileServer = 'http://localhost:6789/hot/{z}/{x}/{y}.png'

export default ({ ride }) => (
  <Map center={ride.bounds_center} zoom={13}>
    <TileLayer url={tileServer}
               attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    />
    <GpxLayer url={ride.gpx_file.url} />
  </Map>
)
