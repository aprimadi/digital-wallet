import { schema } from 'normalizr'

export const EntitySchema = new schema.Entity('entities')
export const EntityListSchema = new schema.Array(EntitySchema)