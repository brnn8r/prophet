import io
import pandas as pd
from flask import Flask, request, jsonify
from flask_restful import Resource, Api
from fbprophet import Prophet

app = Flask(__name__)
api = Api(app)

class DataFile(Resource):
    def post(self):

       df = pd.read_csv(io.BytesIO(request.data), encoding='utf8')

       model = Prophet()
       model.fit(df)

       future_df = model.make_future_dataframe(periods=365)

       forecast = model.predict(future_df)

       return forecast.to_csv()

api.add_resource(DataFile, '/predict')


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')