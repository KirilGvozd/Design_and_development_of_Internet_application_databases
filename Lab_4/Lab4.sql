-- Task 6
SELECT geom.STGeometryType() AS GeometryType FROM ne_50m_admin_1_states_provinces;

-- Task 7
SELECT geom.STSrid AS SRID FROM ne_50m_admin_1_states_provinces;

-- Task 8
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ne_50m_admin_1_states_provinces' AND DATA_TYPE != '%geometry%';

SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'geometry_columns';

-- Task 9
SELECT geom.STAsText() AS WKT FROM ne_50m_admin_1_states_provinces;

-- Task 10
-- Task 10.1
SELECT firstObject.geom.STIntersection(secondObject.geom) AS Intersection
FROM ne_50m_admin_1_states_provinces firstObject, ne_50m_admin_1_states_provinces secondObject
WHERE firstObject.qgs_fid = 1 AND secondObject.qgs_fid = 1;

SELECT firstObject.geom.STIntersection(secondObject.geom) AS Intersection
FROM ne_50m_admin_1_states_provinces firstObject, ne_50m_admin_1_states_provinces secondObject
WHERE firstObject.qgs_fid = 1 AND secondObject.qgs_fid = 3;

SELECT firstObject.geom.STIntersection(secondObject.geom) AS Intersection
FROM ne_50m_admin_1_states_provinces firstObject, ne_50m_admin_1_states_provinces secondObject
WHERE firstObject.qgs_fid = 10 AND secondObject.qgs_fid = 100;

-- Task 10.2
SELECT geom.STPointN(1).ToString() AS Coordinates FROM ne_50m_admin_1_states_provinces WHERE qgs_fid = 1;
SELECT geom.STPointN(1).ToString() AS Coordinates FROM ne_50m_admin_1_states_provinces WHERE qgs_fid = 150;

-- Task 10.3
SELECT geom.STArea() AS Area FROM ne_50m_admin_1_states_provinces WHERE qgs_fid = 1;
SELECT geom.STArea() AS Area FROM ne_50m_admin_1_states_provinces WHERE qgs_fid = 228;

-- Task 11
DECLARE @point GEOMETRY;
SET @point = GEOMETRY::STGeomFromText('POINT(-101 48)', 4326);
SELECT @point AS Point;

DECLARE @line GEOMETRY
SET @line = GEOMETRY::STGeomFromText('LINESTRING(-101 48, -101.49 48.6, -101.49 48.9)', 4326);
SELECT @line AS Line;

DECLARE @polygon GEOMETRY;
SET @polygon = GEOMETRY::STGeomFromText('POLYGON((-101.35 48.9, -101.35 48.8, -101.2 48.8, -101.2 48.9, -101.35 48.9))', 4326);
SELECT @polygon AS PolygonGeometry;

-- Task 12
DECLARE @point GEOMETRY;
SET @point = GEOMETRY::STGeomFromText('POINT(-101 48)', 4326);
SELECT * FROM ne_50m_admin_1_states_provinces WHERE geom.STContains(@point) = 1;

DECLARE @line GEOMETRY
SET @line = GEOMETRY::STGeomFromText('LINESTRING(-101 48, -101.49 48.6, -101.49 48.9)', 4326);
SELECT * FROM ne_50m_admin_1_states_provinces WHERE geom.STContains(@line) = 1;

DECLARE @polygon GEOMETRY;
SET @polygon = GEOMETRY::STGeomFromText('POLYGON((-101.35 48.9, -101.35 48.8, -101.2 48.8, -101.2 48.9, -101.35 48.9))', 4326);
SELECT * FROM ne_50m_admin_1_states_provinces WHERE geom.STContains(@polygon) = 1;

-- Task 13
CREATE SPATIAL INDEX SpatialIndex_new
ON [dbo].[ne_50m_admin_1_states_provinces] ([geom])
USING GEOMETRY_GRID

DECLARE @searchPoint GEOMETRY;
SET @searchPoint = GEOMETRY::STGeomFromText('POINT(20 20)', 4326);

SELECT TOP 1 *
FROM [dbo].[ne_50m_admin_1_states_provinces] WITH(INDEX(SpatialIndex_new))
WHERE [geom].STIntersects(@searchPoint.STBuffer(5)) = 1;

INSERT INTO [dbo].[ne_50m_admin_1_states_provinces] (geom)
VALUES
    (GEOMETRY::STGeomFromText('POINT(20 20)', 4326)),
    (GEOMETRY::STGeomFromText('POLYGON((30 30, 30 40, 40 40, 40 30, 30 30))', 4326)),
    (GEOMETRY::STGeomFromText('LINESTRING(10 10, 15 15, 20 20)', 4326));

UPDATE STATISTICS [dbo].[ne_50m_admin_1_states_provinces] WITH FULLSCAN;

-- Task 14
CREATE PROCEDURE GetSpatialObjectFromPoint
    @latitude DECIMAL(13, 10),
    @longitude DECIMAL(14, 10)
AS
BEGIN
    DECLARE @spatialObject GEOMETRY;

    DECLARE @point GEOMETRY;
    SET @point = GEOMETRY::STPointFromText('POINT(' + CAST(@longitude AS VARCHAR(20)) + ' ' + CAST(@latitude AS VARCHAR(20)) + ')', 4326);

    SELECT @spatialObject = [geom]
    FROM [dbo].[ne_50m_admin_1_states_provinces]
    WHERE [geom].STContains(@point) = 1;

    SELECT @spatialObject AS SpatialObject;
END;

EXEC GetSpatialObjectFromPoint @latitude = 20, @longitude = 20;