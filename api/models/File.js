const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const FileSchema = new Schema({
  shield: String,
  name: String,
  location: String,
  author: { type: Schema.ObjectId, ref: 'users' },
  size: Number,
  type: String,
},
  {
    timestamps: true
  });

module.exports = Image = mongoose.model('files', FileSchema);
