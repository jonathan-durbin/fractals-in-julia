using Images, FileIO


function mandelbrot(;
        image_size:: Tuple{Int, Int} = (1080, 1920),
        center_point:: Tuple{Float64, Float64} = (0.0, -0.5),
        zoom:: Int = 1,
        file_name:: Union{String, Nothing} = nothing,
    )

    aspect_ratio = image_size[2]/image_size[1]
    max_iters = 100

    x = [0, 1.5]
    y = [0, x[2]*aspect_ratio]
    x[1], y[1] = -x[2], -y[2]
    x = map(a -> center_point[1] + a/zoom, x)
    y = map(a -> center_point[2] + a/zoom, y)
    scale = [
        (x[2] - x[1])/image_size[1],
        (y[2] - y[1])/image_size[2],
    ]

    image = zeros(RGB{Float32}, image_size...)
    v = colorview(RGB, image)

    for i in CartesianIndices(image)
        c = 0
        z = complex(y[1] + i[2]*scale[2], x[1] + i[1]*scale[1])
        z_curr = z
        while v[i[1], i[2]] == RGB{Float32}(0, 0, 0) && c <= max_iters
            if abs(z_curr) > 2
                v[i[1], i[2]] = RGB{Float32}(c/255, c/255, c/255)
            end
            z_curr = z_curr^2 + z
            c += 1
        end
    end

    !isnothing(file_name) && save(file_name, image)
end

mandelbrot()

# if abspath(PROGRAM_FILE) == @__FILE__
#     mandelbrot(
#         image_size = (1080, 1920),
#         center_point = (0, -0.5),
#         zoom = 1,
#         file_name = "test.png"
#     )
# end
