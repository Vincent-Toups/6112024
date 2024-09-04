from tensorflow import keras
from tensorflow.keras import layers

import pandas as pd
import numpy as np

from math import floor, ceil

data = pd.read_csv("wider_data.csv");
numerical_data = data[data.columns[2:]].values*1.0;
numerical_data = numerical_data.astype('float32');

n_col = numerical_data.shape[1];

n_rep = 2;


input = keras.Input(shape=(n_col,))

encoder = layers.Dropout(0.3)(input);
encoder = layers.Dense(64, activation='relu')(encoder);
encoder = layers.Dense(32, activation='relu')(encoder);
encoder = layers.Dense(16, activation='relu')(encoder);
encoder = layers.Dense(8, activation='relu')(encoder);

representer = layers.Dense(n_rep, activation='relu')(encoder);

decoder = layers.Dense(8, activation='relu')(representer);
decoder = layers.Dense(16, activation='relu')(decoder);
decoder = layers.Dense(32, activation='relu')(decoder);
decoder = layers.Dense(64, activation='relu')(decoder);
decoder = layers.Dense(n_col, activation='linear')(decoder);

auto_encoder = keras.Model(input, decoder);
auto_encoder.compile(optimizer='adam', loss='binary_crossentropy');

encoder=keras.Model(input, representer);

metrics = auto_encoder.fit(numerical_data, numerical_data,
                 epochs=2000,
                 batch_size=50,
                 shuffle=True);
                 
keras.models.save_model(auto_encoder, "model_auto_encoder");
keras.models.save_model(encoder, "model_encoder");

encoded = encoder.predict(numerical_data);
encoded = pd.DataFrame(encoded, columns=['D1','D2']);

def encompos_percentage(d,percentage):
    d = sorted(d);
    n = round(len(d)*percentage);
    n_drop = len(d)-n;
    n_drop_low = floor(n_drop/2);
    n_drop_high = ceil(n_drop/2);
    chopped = d[n_drop_low:-n_drop_high];
    return [chopped[0], chopped[-1]];

def get_limits(df,p):
    return {"xl":encompos_percentage(df['D1'],p),
            "yl":encompos_percentage(df['D2'],p)};
    

limits = get_limits(encoded, 0.9);

from plotnine import *

the_plot = (ggplot(encoded,aes('D1','D2')) + geom_point() + xlim(limits["xl"][0],limits["xl"][1]) +
 ylim(limits["yl"][0],limits["yl"][1]));

ggplot.save(the_plot,filename="encoded_rep.png");
