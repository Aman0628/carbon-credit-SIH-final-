import express from 'express'
import { mainRouter } from './routes/router';
import cors from 'cors';
import dotenv from 'dotenv'
dotenv.config();

const app = express();
const port = process.env.PORT || 3000;
// routes
app.use(cors());
app.use(express.json());
app.use('/api/v1', mainRouter);



app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
